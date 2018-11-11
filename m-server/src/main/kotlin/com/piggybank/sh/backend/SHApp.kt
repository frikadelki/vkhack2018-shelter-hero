package com.piggybank.sh.backend

import com.piggybank.sh.backend.db.*
import com.piggybank.sh.generated.*
import com.piggybank.sh.genex.locationOf
import com.piggybank.sh.genex.timeWindowOf
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction

class SearchTaskCalc(val task: Task, val eventsDump: Map<Int, EventCalc>)

class EventCalc(val event: Event,
                val demandEntity: OrderDemandEntity,
                val venue: VenueEntity?,
                val shelter: ShelterEntity?)

class SHApp(db: Database) {
    private val repo = SHRepo(db)

    fun shelterMapObjects(): Iterable<ShelterMapObject> = repo.shelterMapObjects()

    fun venueMapObjects(): Iterable<VenueMapObject> = repo.venuesMapObjects()

    fun orderEntity(orderId: Int): SheltersOrderEntity  = repo.orderEntity(orderId)

    fun prepareSearchTask(params: SearchParams, acceptableOrdersTags: List<String>): SearchTaskCalc = transaction {
        var eventsIdsSequence = 0
        fun nextEventId() = eventsIdsSequence++

        val eventsDump = mutableMapOf<Int, EventCalc>()

        fun mapPlainDemand(demandEntity: OrderDemandEntity): Demand {
            val event = Event.newBuilder()
                    .setId(nextEventId())
                    .setLocation(locationOf(params.start))
                    .setTimeWindow(demandEntity.timeWindow ?: timeWindowOf(0, 24 * 60))
                    .setDuration(demandEntity.duration)
                    .build()
            eventsDump[event.id] = EventCalc(event, demandEntity, null, null)

            return Demand.newBuilder()
                    .addAllEvents(listOf(event))
                    .build()
        }

        fun mapShelterAction(demandEntity: OrderDemandEntity): Demand {
            val shelter = demandEntity.shelter!!
            val event = Event.newBuilder()
                    .setId(nextEventId())
                    .setLocation(locationOf(shelter.location))
                    .setTimeWindow(demandEntity.timeWindow ?: timeWindowOf(8 * 60, 20 * 60))
                    .setDuration(demandEntity.duration)
                    .build()
            eventsDump[event.id] = EventCalc(event, demandEntity, null, shelter)

            return Demand.newBuilder()
                    .addAllEvents(listOf(event))
                    .build()
        }

        fun mapVenueAction(demandEntity: OrderDemandEntity): Demand {
            val suitableVenues = VenueEntity.all().filter { venueEntity ->
                venueEntity.tags.contains(demandEntity.suitableVenueTag!!)
            }

            val events = suitableVenues.map {
                val event = Event.newBuilder()
                        .setId(nextEventId())
                        .setLocation(locationOf(it.location))
                        .setTimeWindow(demandEntity.timeWindow ?:timeWindowOf(8 * 60, 20 * 60))
                        .setDuration(demandEntity.duration)
                        .build()
                eventsDump[event.id] = EventCalc(event, demandEntity, it, null)
                return@map event
            }

            return Demand.newBuilder()
                    .addAllEvents(events)
                    .build()
        }

        fun mapDemand(demandEntity: OrderDemandEntity): Demand {
            return when(demandEntity.type) {
                OrderDemandType.Plain -> mapPlainDemand(demandEntity)
                OrderDemandType.ShelterAction -> mapShelterAction(demandEntity)
                OrderDemandType.VenueAction -> mapVenueAction(demandEntity)
            }
        }

        fun mapShelterOrderEntity(orderEntity: SheltersOrderEntity): Order {
            val demands = orderEntity.demands.map { demandEntity ->
                mapDemand(demandEntity)
            }
            return Order.newBuilder()
                    .setId(orderEntity.id.value)
                    .addAllDemands(demands)
                    .build()
        }

        val openOrders = repo.openSheltersOrders()
                .filter { order ->
                    return@filter acceptableOrdersTags.isEmpty() || acceptableOrdersTags.any { order.tags.contains(it) }
                }
                .map(::mapShelterOrderEntity)

        val task = Task.newBuilder()
                .setParams(params)
                .addAllOrders(openOrders)
                .build()

        return@transaction SearchTaskCalc(task, eventsDump)
    }
}
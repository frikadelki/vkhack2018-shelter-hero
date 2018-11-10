package com.piggybank.sh.backend

import com.piggybank.sh.backend.db.OrderDemandEntity
import com.piggybank.sh.backend.db.OrderDemandType
import com.piggybank.sh.backend.db.SheltersOrderEntity
import com.piggybank.sh.backend.db.VenueEntity
import com.piggybank.sh.generated.*
import com.piggybank.sh.genex.locationOf
import com.piggybank.sh.genex.timeWindowOf
import org.jetbrains.exposed.sql.Database

class SHApp(db: Database) {
    private val repo = SHRepo(db)

    fun shelterMapObjects(): Iterable<ShelterMapObject> = repo.shelterMapObjects()

    fun venueMapObjects(): Iterable<VenueMapObject> = repo.venuesMapObjects()

    fun orderEntity(orderId: Int): SheltersOrderEntity  = repo.orderEntity(orderId)

    fun prepareSearchTask(params: SearchParams, acceptableOrdersTags: List<String>): Task {
        var eventsIdsSequence = 0
        fun nextEventId() = eventsIdsSequence++

        fun mapPlainDemand(demandEntity: OrderDemandEntity): Demand {
            val event = Event.newBuilder()
                    .setId(nextEventId())
                    .setLocation(locationOf(params.start))
                    .setTimeWindow(demandEntity.timeWindow ?: timeWindowOf(0, 24 * 60))
                    .setDuration(demandEntity.duration)
                    .build()

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

            return Demand.newBuilder()
                    .addAllEvents(listOf(event))
                    .build()
        }

        fun mapVenueAction(demandEntity: OrderDemandEntity): Demand {
            val suitableVenues = VenueEntity.all().filter { venueEntity ->
                venueEntity.tags.contains(demandEntity.suitableVenueTag!!)
            }

            val events = suitableVenues.map {
                return@map Event.newBuilder()
                        .setId(nextEventId())
                        .setLocation(locationOf(it.location))
                        .setTimeWindow(demandEntity.timeWindow ?:timeWindowOf(8 * 60, 20 * 60))
                        .setDuration(demandEntity.duration)
                        .build()
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
                    return@filter acceptableOrdersTags.any { order.tags.contains(it) }
                }
                .map(::mapShelterOrderEntity)

        return Task.newBuilder()
                .setParams(params)
                .addAllOrders(openOrders)
                .build()
    }
}
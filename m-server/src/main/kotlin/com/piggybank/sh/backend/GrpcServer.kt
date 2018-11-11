package com.piggybank.sh.backend

import com.piggybank.sh.backend.db.shelterDemand
import com.piggybank.sh.backend.db.venue
import com.piggybank.sh.generated.*
import io.grpc.ServerBuilder
import io.grpc.stub.StreamObserver
import io.grpc.ManagedChannelBuilder
import io.grpc.ManagedChannel

class GrpcServer(private val app: SHApp) {
    private var started = false
    private var shutdown = false

    private val port = 50051
    private val server = ServerBuilder.forPort(port)
            .addService(MapObjectServiceImpl(app))
            .addService(QuestServiceImpl(app, RecommendationsClient("172.20.38.33", 12100)))
            .build()

    fun start() {
        if (started) {
            error("Already started")
        }
        started = true
        server.start()
    }

    fun shutdown() {
        if (!started || shutdown) {
            shutdown = true
            return
        }
        shutdown = true
        server.shutdownNow()
    }
}

class MapObjectServiceImpl(private val app: SHApp) : MapObjectServiceGrpc.MapObjectServiceImplBase() {
    override fun allObjects(request: MapObjectRequest, responseObserver: StreamObserver<MapObjectResponse>) {
        val response = MapObjectResponse.newBuilder()
                .addAllShelters(app.shelterMapObjects())
                .addAllVenues(app.venueMapObjects())
                .build()

        responseObserver.onNext(response)
        responseObserver.onCompleted()
    }
}

class QuestServiceImpl(private val app: SHApp,
                       private val recommendationsClient: RecommendationsClient)
    : QuestsServiceGrpc.QuestsServiceImplBase() {
    override fun search(request: SearchQuestsRequest, responseObserver: StreamObserver<SearchQuestsResponse>) {
        val searchTaskCalc = app.prepareSearchTask(request.params, request.orderTagsList)
        recommendationsClient.searcher.findRecommendations(searchTaskCalc.task, object : StreamObserver<Recommendations> {
            override fun onNext(value: Recommendations) {
                fun mapTrip(trip: Trip): ShelterQuest {
                    val orderEntity = app.orderEntity(trip.orderId)

                    val fakishShelter =  Shelter.newBuilder()
                            .setId(orderEntity.shelter.id.value)
                            .setName(orderEntity.shelter.name)
                            .setIconName(orderEntity.shelter.iconName)
                            .build()

                    val order = ShelterOrder.newBuilder()
                            .setTitle(orderEntity.title)
                            .setDescription(orderEntity.description)
                            .addAllTags(orderEntity.tags)
                            .setShelter(fakishShelter)
                            .build()

                    val steps = trip.actionsList.map {
                        val eventCalc = searchTaskCalc.eventsDump[it.eventId]!!
                        val demandEntity = eventCalc.demandEntity
                        return@map ShelterQuestStep.newBuilder()
                                .setDemand(demandEntity.shelterDemand())
                                .setVenue(eventCalc.venue?.venue())
                                .setTimeWindow(eventCalc.event.timeWindow)
                                .setDuration(eventCalc.event.duration)
                                .build()
                    }

                    return ShelterQuest.newBuilder()
                            .setOrder(order)
                            .addAllSteps(steps)
                            .build()
                }

                val quests = value.recommendationsList.map(::mapTrip)

                val response = SearchQuestsResponse.newBuilder()
                        .addAllQuests(quests)
                        .build()
                responseObserver.onNext(response)
                responseObserver.onCompleted()
            }

            override fun onError(t: Throwable?) {
                responseObserver.onError(Throwable(t))
            }

            override fun onCompleted() {
            }
        })
    }
}

class RecommendationsClient(host: String, port: Int) {
    private val channel: ManagedChannel = ManagedChannelBuilder.forAddress(host, port)
            .usePlaintext(true)
            .build()!!

    val searcher = RecommendationsSearcherGrpc.newStub(channel)!!

    fun shutdown() {
        channel.shutdown()
    }
}

class ShelterQuestRecordServiceImpl : ShelterQuestRecordServiceGrpc.ShelterQuestRecordServiceImplBase() {
    override fun start(request: ShelterQuestStartRequest?, responseObserver: StreamObserver<ShelterQuestResponse>?) {
    }
}
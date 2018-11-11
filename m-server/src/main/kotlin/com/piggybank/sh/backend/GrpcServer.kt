package com.piggybank.sh.backend

import com.piggybank.sh.backend.db.QuestRecordEntity
import com.piggybank.sh.backend.db.QuestRecordTable
import com.piggybank.sh.backend.db.toShelterQuestRecord
import com.piggybank.sh.generated.*
import io.grpc.ServerBuilder
import io.grpc.stub.StreamObserver
import io.grpc.ManagedChannelBuilder
import io.grpc.ManagedChannel
import org.jetbrains.exposed.sql.transactions.transaction

class GrpcServer(private val app: SHApp) {
    private var started = false
    private var shutdown = false

    // private val recommendationsHost = "172.20.38.33"
    private val recommendationsHost = "vps456808.ovh.net"
    private val recommendationsPort = 12100
    private val port = 50051
    private val server = ServerBuilder.forPort(port)
            .addService(MapObjectServiceImpl(app))
            .addService(QuestServiceImpl(app, RecommendationsClient(recommendationsHost, recommendationsPort)))
            .addService(ShelterQuestRecordServiceImpl(app))
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
    override fun search(request: SearchQuestsRequest, responseObserver: StreamObserver<SearchQuestsResponse>) = transaction {

        val searchTaskCalc = app.prepareSearchTask(request.params, request.orderTagsList)

        val recommendations = recommendationsClient.searcher.findRecommendations(searchTaskCalc.task)!!
        val quests = recommendations.recommendationsList.map { app.mapTrip(it, searchTaskCalc) }
        val response = SearchQuestsResponse.newBuilder()
                .addAllQuests(quests)
                .build()
        responseObserver.onNext(response)
        responseObserver.onCompleted()
    }

}

class RecommendationsClient(host: String, port: Int) {
    private val channel: ManagedChannel = ManagedChannelBuilder.forAddress(host, port)
            .usePlaintext(true)
            .build()!!

    val searcher = RecommendationsSearcherGrpc.newBlockingStub(channel)!!

    fun shutdown() {
        channel.shutdown()
    }
}

class ShelterQuestRecordServiceImpl(private val app: SHApp) : ShelterQuestRecordServiceGrpc.ShelterQuestRecordServiceImplBase() {
    override fun list(request: ShelterQuestListRequest, responseObserver: StreamObserver<ShelterQuestListResponse>) = transaction {
        val questRecordsEntities = QuestRecordEntity.find {
            QuestRecordTable.principalToken eq request.token
        }
        val questRecords = questRecordsEntities.map {
            it.toShelterQuestRecord()
        }

        val response = ShelterQuestListResponse.newBuilder()
                .addAllQuestsRecords(questRecords)
                .build()
        responseObserver.onNext(response)
        responseObserver.onCompleted()
    }

    override fun start(request: ShelterQuestStartRequest, responseObserver: StreamObserver<ShelterQuestResponse>) = transaction {
        val record = app.startQuest(request.token, request.shelterQuest)
        val response = ShelterQuestResponse.newBuilder()
                .setShelterQuestRecord(record.toShelterQuestRecord())
                .build()
        responseObserver.onNext(response)
        responseObserver.onCompleted()
    }
}
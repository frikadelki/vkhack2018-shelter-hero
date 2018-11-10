package com.piggybank.sh.backend

import com.piggybank.sh.generated.MapObjectRequest
import com.piggybank.sh.generated.MapObjectResponse
import com.piggybank.sh.generated.MapObjectServiceGrpc
import io.grpc.ServerBuilder
import io.grpc.stub.StreamObserver

class GrpcServer(private val app: SHApp) {
    private var started = false
    private var shutdown = false

    private val port = 50051
    private val server = ServerBuilder.forPort(port)
            .addService(MapObjectServiceImpl(app))
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
    override fun allObjects(request: MapObjectRequest?, responseObserver: StreamObserver<MapObjectResponse>?) {
        super.allObjects(request, responseObserver)
    }
}
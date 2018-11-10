package com.piggybank.sh.backend

import org.jetbrains.exposed.sql.Database
import org.slf4j.LoggerFactory

private val LOG = LoggerFactory.getLogger("backend/Main.kt")

fun main(args: Array<String>) {
    LOG.info("Connecting to db...")
    val db = Database.connect("jdbc:h2:mem:test;DB_CLOSE_DELAY=-1", "org.h2.Driver")

    LOG.info("Initializing app...")
    val app = SHApp(db)

    val httpServer = HttpServer(app)
    val grpcServer = GrpcServer(app)

    LOG.info("Starting http server...")
    httpServer.start()

    LOG.info("Starting grpc server...")
    grpcServer.start()

    Runtime.getRuntime().addShutdownHook(object : Thread() {
        override fun run() {
            // Use stderr here since the logger may have been reset by its JVM shutdown hook.
            System.err.println("*** JVM is shutting down")
            httpServer.shutdown()
            grpcServer.shutdown()
            System.err.println("*** server shut down")
        }
    })
}


package com.piggybank.sh.backend

import io.ktor.application.Application
import io.ktor.application.call
import io.ktor.http.ContentType
import io.ktor.response.respondText
import io.ktor.routing.get
import io.ktor.routing.routing
import io.ktor.server.engine.embeddedServer
import io.ktor.server.netty.Netty
import java.util.concurrent.TimeUnit

class HttpServer(private val app: SHApp) {
    private var started = false
    private var shutdown = false

    //private val host = "0.0.0.0"
    private val host = "127.0.0.1"
    private val port = 8080
    private val server = embeddedServer(Netty, host = host,  port = port) {
        setupBasicRouting(app)
    }

    private fun Application.setupBasicRouting(app: SHApp) {
        routing {
            get("/") {
                call.respondText("Hello World!", ContentType.Text.Plain)
            }
        }
    }

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
        server.stop(1, 100, TimeUnit.MILLISECONDS)
    }
}
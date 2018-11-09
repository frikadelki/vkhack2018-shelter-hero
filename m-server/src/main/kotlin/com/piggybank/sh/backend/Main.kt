package com.piggybank.sh.backend

import io.ktor.application.Application
import io.ktor.application.call
import io.ktor.http.ContentType
import io.ktor.response.respondText
import io.ktor.routing.get
import io.ktor.routing.routing
import io.ktor.server.engine.embeddedServer
import io.ktor.server.netty.Netty
import org.jetbrains.exposed.sql.Database


fun main(args: Array<String>) {
    val db = Database.connect("jdbc:h2:mem:test;DB_CLOSE_DELAY=-1", "org.h2.Driver")
    val app = SHApp(db)
    val server = embeddedServer(Netty, port = 8080, host = "127.0.0.1") {
        setupBasicRouting(app)
    }
    server.start(wait = true)
}

private fun Application.setupBasicRouting(app: SHApp) {
    routing {
        get("/") {
            call.respondText("Hello World!", ContentType.Text.Plain)
        }
    }
}


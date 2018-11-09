package com.piggybank.sh.backend

import org.jetbrains.exposed.sql.Database

class SHApp(db: Database) {
    private val repo = SHRepo(db)
}
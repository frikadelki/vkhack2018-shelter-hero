package com.piggybank.sh.backend

import com.piggybank.sh.generated.ShelterMapObject
import org.jetbrains.exposed.sql.Database

class SHApp(db: Database) {
    private val repo = SHRepo(db)

    fun shelterMapObjects(): Iterable<ShelterMapObject> = repo.shelterMapObjects()
}
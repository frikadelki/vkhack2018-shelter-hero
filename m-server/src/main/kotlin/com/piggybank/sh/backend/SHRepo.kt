package com.piggybank.sh.backend

import com.piggybank.sh.backend.db.ShelterEntity
import com.piggybank.sh.backend.db.SheltersOrdersTable
import com.piggybank.sh.backend.db.SheltersTable
import com.piggybank.sh.backend.db.VolunteersTable
import com.piggybank.sh.generated.Shelter
import com.piggybank.sh.generated.ShelterMapObject
import com.piggybank.sh.genex.geoPoint
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.SchemaUtils
import org.jetbrains.exposed.sql.transactions.transaction

class SHRepo(private val db: Database) {
    init {
        transaction(db) {
            SchemaUtils.create(
                    VolunteersTable,
                    SheltersTable,
                    SheltersOrdersTable)
        }

        transaction(db) {
            ShelterEntity.new {
                name = "Добрый Парень"
                iconName = "paw"
                location = geoPoint(10.0, 15.0)
            }
            ShelterEntity.new {
                name = "Душенька"
                iconName = "kitties"
                location = geoPoint(20.0, 25.0)
            }
        }
    }

    fun shelterMapObjects(): Iterable<ShelterMapObject> = transaction(db) {
        return@transaction ShelterEntity.all().map {
            return@map ShelterMapObject.newBuilder()
                    .setShelter(it.shelter())
                    .addAllAvailableOrders(emptyList())
                    .build()
        }
    }
}

fun ShelterEntity.shelter(): Shelter {
    return Shelter.newBuilder()
            .setId(id.value)
            .setName(name)
            .setCoordinate(location)
            .build()
}
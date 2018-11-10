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
                iconName = "shelterIcon"
                location = geoPoint(55.756683, 37.622341)
            }
            ShelterEntity.new {
                name = "Душенька"
                iconName = "shelterIcon"
                location = geoPoint(55.776683, 37.618341)
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
            .setIconName(iconName)
            .setCoordinate(location)
            .build()
}
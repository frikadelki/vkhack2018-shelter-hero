package com.piggybank.sh.backend.db

import com.piggybank.sh.generated.GeoPoint
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.sql.Column
import kotlin.reflect.KProperty

class GeoPointDelegator(private val latColumn: Column<Double>, private val lonColumn: Column<Double>) {
    operator fun getValue(entity: IntEntity, property: KProperty<*>): GeoPoint {
        return entity.run {
            return@run GeoPoint.newBuilder()
                    .setLat(latColumn.lookup())
                    .setLon(lonColumn.lookup())
                    .build()
        }
    }

    operator fun setValue(entity: IntEntity, property: KProperty<*>, point: GeoPoint) {
        entity.apply {
            latColumn.setValue(entity, this@GeoPointDelegator::latColumn, point.lat)
            lonColumn.setValue(entity, this@GeoPointDelegator::lonColumn, point.lon)
        }
    }
}
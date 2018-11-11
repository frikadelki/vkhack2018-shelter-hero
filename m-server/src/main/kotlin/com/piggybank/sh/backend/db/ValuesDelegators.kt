package com.piggybank.sh.backend.db

import com.google.gson.GsonBuilder
import com.google.protobuf.Message
import com.google.protobuf.util.JsonFormat
import com.piggybank.sh.generated.GeoPoint
import com.piggybank.sh.generated.TimeWindow
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

class StringListDelegator(private val textColumn: Column<String>, private val separator: Char = ',') {
    operator fun getValue(entity: IntEntity, property: KProperty<*>): List<String> {
        return entity.run {
            val columnValue = textColumn.lookup()
            val listValues = columnValue.split(separator)
            return@run if (listValues.isEmpty()
                    || (listValues.count() == 1 && listValues[0].isBlank())) emptyList() else listValues
        }
    }

    operator fun setValue(entity: IntEntity, property: KProperty<*>, list: List<String>) {
        entity.apply {
            val columnValue = list.joinToString(separator.toString())
            textColumn.setValue(entity, this@StringListDelegator::textColumn, columnValue)
        }
    }
}

class TimeWindowDelegator(private val textColumn: Column<String>) {
    operator fun getValue(entity: IntEntity, property: KProperty<*>): TimeWindow {
        return entity.run {
            val columnValue = textColumn.lookup()
            val resultBuilder = TimeWindow.newBuilder()
            JsonFormat.parser().merge(columnValue, resultBuilder)
            return@run resultBuilder.build()
        }
    }

    operator fun setValue(entity: IntEntity, property: KProperty<*>, timeWindow: TimeWindow) {
        entity.apply {
            val columnValue = JsonFormat.printer().print(timeWindow)
            textColumn.setValue(entity, this@TimeWindowDelegator::textColumn, columnValue)
        }
    }
}

class ProtobufMessageDelegator<TMessage : Message>(private val textColumn: Column<String>,
                                                   private val builderFactory: () -> Message.Builder) {
    operator fun getValue(entity: IntEntity, property: KProperty<*>): TMessage {
        return entity.run {
            val columnValue = textColumn.lookup()
            val resultBuilder = builderFactory()
            JsonFormat.parser().merge(columnValue, resultBuilder)
            return@run resultBuilder.build() as TMessage
        }
    }

    operator fun setValue(entity: IntEntity, property: KProperty<*>, message: TMessage) {
        entity.apply {
            val columnValue = JsonFormat.printer().print(message)
            textColumn.setValue(entity, this@ProtobufMessageDelegator::textColumn, columnValue)
        }
    }
}

class ProtobufMessageDelegatorNullable<TMessage : Message>(private val textColumn: Column<String?>,
                                                           private val builderFactory: () -> Message.Builder) {
    operator fun getValue(entity: IntEntity, property: KProperty<*>): TMessage? {
        return entity.run {
            val columnValue = textColumn.lookup() ?: return@run null
            val resultBuilder = builderFactory()
            JsonFormat.parser().merge(columnValue, resultBuilder)
            return@run resultBuilder.build() as TMessage
        }
    }

    operator fun setValue(entity: IntEntity, property: KProperty<*>, messageOrNull: TMessage?) {
        entity.apply {
            val message = messageOrNull ?: return@apply
            val columnValue = JsonFormat.printer().print(message)
            textColumn.setValue(entity, this@ProtobufMessageDelegatorNullable::textColumn, columnValue)
        }
    }
}
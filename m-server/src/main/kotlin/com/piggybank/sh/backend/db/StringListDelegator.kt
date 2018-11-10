package com.piggybank.sh.backend.db

import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.sql.Column
import kotlin.reflect.KProperty

class StringListDelegator(private val textColumn: Column<String>, private val separator: Char = ',') {
    operator fun getValue(entity: IntEntity, property: KProperty<*>): List<String> {
        return entity.run {
            val columnValue = textColumn.lookup()
            return@run columnValue.split(separator)
        }
    }

    operator fun setValue(entity: IntEntity, property: KProperty<*>, list: List<String>) {
        entity.apply {
            val columnValue = list.joinToString(separator.toString())
            textColumn.setValue(entity, this@StringListDelegator::textColumn, columnValue)
        }
    }
}
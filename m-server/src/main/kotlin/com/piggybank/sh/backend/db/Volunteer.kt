package com.piggybank.sh.backend.db

import org.jetbrains.exposed.dao.EntityID
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.IntIdTable

object VolunteersTable : IntIdTable() {
    val login = varchar("name", 50)
    val passwordHash = text("password_hash")
}

class VolunteerEntity(id: EntityID<Int>) : IntEntity(id) {
    companion object : IntEntityClass<VolunteerEntity>(VolunteersTable)

    var login by VolunteersTable.login
    var passwordHash by VolunteersTable.passwordHash
}

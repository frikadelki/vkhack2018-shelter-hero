package com.piggybank.sh.backend.db

import com.piggybank.runtime.SHA1_HEX_STRING_LENGTH
import org.jetbrains.exposed.dao.EntityID
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.IntIdTable

object VolunteersTable : IntIdTable() {
    val login = varchar("name", 50)
    val passwordHash = varchar("password_hash", SHA1_HEX_STRING_LENGTH)
}

class VolunteerEntity(id: EntityID<Int>) : IntEntity(id) {
    companion object : IntEntityClass<VolunteerEntity>(VolunteersTable)

    var login by VolunteersTable.login
    var passwordHash by VolunteersTable.passwordHash
}
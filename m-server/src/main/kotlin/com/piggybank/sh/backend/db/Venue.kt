package com.piggybank.sh.backend.db

import org.jetbrains.exposed.dao.*

object VenuesTable : IntIdTable() {
    val name = text("name")
    val iconName = text("icon_name")
    val locationLat = double("location_lat")
    val locationLon = double("location_lon")
    val tags = text("tags")
}

class VenueEntity(id: EntityID<Int>) : IntEntity(id) {
    companion object : IntEntityClass<VenueEntity>(VenuesTable)

    var name by VenuesTable.name

    var iconName by VenuesTable.iconName

    var location by GeoPointDelegator(VenuesTable.locationLat, VenuesTable.locationLon)

    var tags by StringListDelegator(VenuesTable.tags)
}
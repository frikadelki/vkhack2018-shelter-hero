package com.piggybank.sh.backend.db

import org.jetbrains.exposed.dao.*

object SheltersTable : IntIdTable() {
    val name = text("name")
    val iconName = text("icon_name")
    val locationLat = double("location_lat")
    val locationLon = double("location_lon")
}

class ShelterEntity(id: EntityID<Int>) : IntEntity(id) {
    companion object : IntEntityClass<ShelterEntity>(SheltersTable)

    var name by SheltersTable.name

    var iconName by SheltersTable.iconName

    var location by GeoPointDelegator(SheltersTable.locationLat, SheltersTable.locationLon)

    /*private var locationLat by SheltersTable.locationLat
    private var locationLon by SheltersTable.locationLon

    var location: GeoPoint
        get() = GeoPoint.newBuilder()
                .setLat(SheltersTable.locationLat.lookup())
                .setLon(SheltersTable.locationLon.lookup())
                .build()
        set(value) {
            locationLat = value.lat
            locationLon = value.lon
        }*/
}

object SheltersOrdersTable : IntIdTable() {
    val shelter = reference("shelter_ref", SheltersTable)

    val title = text("title")
    val description = text("description")
    val tags = text("tags")

    // TODO: demands
}

class SheltersOrderEntity(id: EntityID<Int>) : IntEntity(id) {
    companion object : IntEntityClass<SheltersOrderEntity>(SheltersOrdersTable)

    var title by SheltersOrdersTable.title

    var description by SheltersOrdersTable.description

    var tags by StringListDelegator(SheltersOrdersTable.tags)

    /*private val RAW_TAGS_DELIMETER = ','
    private var rawTags by SheltersOrdersTable.tags

    var tags : List<String>
        get() = rawTags.split(RAW_TAGS_DELIMETER)
        set(value) {
            rawTags = value.joinToString(RAW_TAGS_DELIMETER.toString())
        }*/
}


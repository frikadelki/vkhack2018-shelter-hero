package com.piggybank.sh.backend.db

import com.piggybank.sh.generated.TimeWindow
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
}

object SheltersOrdersTable : IntIdTable() {
    val title = text("title")
    val description = text("description")
    val tags = text("tags")

    // parent
    val shelter = reference("shelter_ref", SheltersTable)
}

class SheltersOrderEntity(id: EntityID<Int>) : IntEntity(id) {
    companion object : IntEntityClass<SheltersOrderEntity>(SheltersOrdersTable)

    var title by SheltersOrdersTable.title

    var description by SheltersOrdersTable.description

    var tags by StringListDelegator(SheltersOrdersTable.tags)

    val demands by OrderDemandEntity referrersOn OrdersDemandsTable.order

    fun addDemand(builder: OrderDemandEntity.() -> Unit) {
        OrderDemandEntity.new {
            builder()
            order = this@SheltersOrderEntity
        }
    }

    var shelter by ShelterEntity referencedOn SheltersOrdersTable.shelter
}

object OrdersDemandsTable : IntIdTable() {
    val description = text("description")

    val type = text("type") // OrderDemandType

    val duration = integer("duration")

    val timeWindow = text("time_window").nullable()

    val shelter = reference("shelter", SheltersTable).nullable()

    val suitableVenueTag = text("suitable_venue").nullable()

    //val venue = reference("venue", VenuesTable).nullable()

    // parent
    val order = reference("order", SheltersOrdersTable)
}

enum class OrderDemandType {
    Plain,          // work handled outside of the app domain
    ShelterAction,  // work requires shelter visit
    VenueAction,    // work requires venue visit
    ;
}

class OrderDemandEntity(id: EntityID<Int>) : IntEntity(id) {
    companion object : IntEntityClass<OrderDemandEntity>(OrdersDemandsTable)

    var description by OrdersDemandsTable.description

    private var _type by OrdersDemandsTable.type

    var type: OrderDemandType
        get() = OrderDemandType.valueOf(_type)
        set(value) {
            _type = value.name
        }

    var duration by OrdersDemandsTable.duration

    var timeWindow by ProtobufMessageDelegatorNullable<TimeWindow>(OrdersDemandsTable.timeWindow) { TimeWindow.newBuilder() }

    var shelter by ShelterEntity optionalReferencedOn OrdersDemandsTable.shelter

    var suitableVenueTag by OrdersDemandsTable.suitableVenueTag

    //var venue by VenueEntity optionalReferencedOn OrdersDemandsTable.venue

    var order by SheltersOrderEntity referencedOn OrdersDemandsTable.order
}

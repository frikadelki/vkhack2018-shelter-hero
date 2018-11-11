package com.piggybank.sh.backend.db

import com.piggybank.sh.generated.Shelter
import com.piggybank.sh.generated.ShelterDemand
import com.piggybank.sh.generated.Venue

fun VenueEntity.venue(): Venue {
    return Venue.newBuilder()
            .setId(id.value)
            .setCoordinate(location)
            .setIconName(iconName)
            .addAllTags(tags)
            .build()
}

fun ShelterEntity.shelter(): Shelter {
    return Shelter.newBuilder()
            .setId(id.value)
            .setName(name)
            .setIconName(iconName)
            .setCoordinate(location)
            .build()
}

fun OrderDemandEntity.shelterDemand(): ShelterDemand {
    return ShelterDemand.newBuilder()
            .setId(id.value)
            .setText(description)
            .build()
}
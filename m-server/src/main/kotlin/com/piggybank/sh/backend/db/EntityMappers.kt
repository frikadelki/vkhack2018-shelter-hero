package com.piggybank.sh.backend.db

import com.piggybank.sh.generated.Shelter
import com.piggybank.sh.generated.ShelterDemand
import com.piggybank.sh.generated.ShelterQuestRecord
import com.piggybank.sh.generated.Venue

fun VenueEntity.toVenue(): Venue {
    return Venue.newBuilder()
            .setId(id.value)
            .setCoordinate(location)
            .setIconName(iconName)
            .addAllTags(tags)
            .build()
}

fun ShelterEntity.toShelter(): Shelter {
    return Shelter.newBuilder()
            .setId(id.value)
            .setName(name)
            .setIconName(iconName)
            .setCoordinate(location)
            .build()
}

fun OrderDemandEntity.toShelterDemand(): ShelterDemand {
    return ShelterDemand.newBuilder()
            .setId(id.value)
            .setText(description)
            .build()
}

fun QuestRecordEntity.toShelterQuestRecord(): ShelterQuestRecord {
    return ShelterQuestRecord.newBuilder()
            .setId(id.value)
            .setShelterQuest(quest)
            .setStatus(status)
            .setStartTime(startTime)
            .addAllDoneDemandsIds(demands.map { it.id.value })
            .setChat(embeddedChat)
            .build()
}
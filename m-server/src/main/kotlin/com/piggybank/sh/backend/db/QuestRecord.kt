package com.piggybank.sh.backend.db

import com.piggybank.sh.generated.ShelterQuest
import com.piggybank.sh.generated.ShelterQuestRecordStatus
import org.jetbrains.exposed.dao.EntityID
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.IntIdTable
import org.jetbrains.exposed.sql.Table

object QuestRecordTable : IntIdTable() {
    val quest = text("quest")

    val startTimeEpochMillis = long("start_time_epoch_millis")

    val status = text("status")
}

class QuestRecordEntity(id: EntityID<Int>) : IntEntity(id) {
    companion object : IntEntityClass<QuestRecordEntity>(SheltersTable)

    var startTimeEpochMillis by QuestRecordTable.startTimeEpochMillis

    var quest by ProtobufMessageDelegator<ShelterQuest>(QuestRecordTable.quest) { ShelterQuest.newBuilder() }

    private var _status by QuestRecordTable.status

    var status: ShelterQuestRecordStatus
        get() = ShelterQuestRecordStatus.valueOf(_status)
        set(value) {
            _status = value.name
        }

    var demands by OrderDemandEntity via QuestRecordsDoneDemands
}

object QuestRecordsDoneDemands : Table() {
    val questRecord = reference("quest_record", QuestRecordTable).primaryKey(0)
    val demand = reference("demand", OrdersDemandsTable).primaryKey(1)
}
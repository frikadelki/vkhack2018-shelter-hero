package com.piggybank.sh.backend.db

import com.piggybank.sh.generated.Chat
import com.piggybank.sh.generated.ShelterQuest
import com.piggybank.sh.generated.ShelterQuestRecordStatus
import org.jetbrains.exposed.dao.EntityID
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.IntIdTable
import org.jetbrains.exposed.sql.Table

object QuestRecordTable : IntIdTable() {
    val quest = text("quest")

    val principalToken = text("principal_token")

    val startTime = integer("start_time_epoch_millis")

    val status = text("status")

    val embeddedChat = text("embedded_chat")
}

class QuestRecordEntity(id: EntityID<Int>) : IntEntity(id) {
    companion object : IntEntityClass<QuestRecordEntity>(QuestRecordTable)

    var quest by ProtobufMessageDelegator<ShelterQuest>(QuestRecordTable.quest) { ShelterQuest.newBuilder() }

    var principalToken by QuestRecordTable.principalToken

    var startTime by QuestRecordTable.startTime

    private var _status by QuestRecordTable.status

    var status: ShelterQuestRecordStatus
        get() = ShelterQuestRecordStatus.valueOf(_status)
        set(value) {
            _status = value.name
        }

    var demands by OrderDemandEntity via QuestRecordsDoneDemandsTable

    var embeddedChat by ProtobufMessageDelegator<Chat>(QuestRecordTable.embeddedChat) { Chat.newBuilder() }
}

object QuestRecordsDoneDemandsTable : Table() {
    val questRecord = reference("quest_record", QuestRecordTable).primaryKey(0)
    val demand = reference("demand", OrdersDemandsTable).primaryKey(1)
}
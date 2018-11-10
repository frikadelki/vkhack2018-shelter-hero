//
//  ShlterQuestRecordController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 10.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation

class ShlterQuestRecordController {
    func start(shelterQuest: Sh_Generated_ShelterQuest, completion: @escaping (_ record: Sh_Generated_ShelterQuestRecord?) -> Void) {

        var request = Sh_Generated_ShelterQuestStartRequest()
        request.shelterQuest = shelterQuest
        request.token = AuthController.shared.token
        let call = try? Sh_Generated_ShelterQuestRecordServiceServiceClient(address: ApiConfig().address).start(request) { response, _ in
            DispatchQueue.main.async {
                if AuthController.shared.fakeResponses {
                    self.fakeStartReponse(shelterQuest: shelterQuest, completion: completion)
                } else {
                    completion(response?.shelterQuestRecord)
                }
            }
        }

        if call == nil {
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }

    private func fakeStartReponse(shelterQuest: Sh_Generated_ShelterQuest, completion: @escaping (_ record: Sh_Generated_ShelterQuestRecord?) -> Void) {
        var record = Sh_Generated_ShelterQuestRecord()
        record.shelterQuest = shelterQuest
        record.status = .inProgress
        completion(record)
    }

    func list(completion: @escaping (_ records: [Sh_Generated_ShelterQuestRecord]?) -> Void) {
        var request = Sh_Generated_ShelterQuestListRequest()
        request.token = AuthController.shared.token
        let call = try? Sh_Generated_ShelterQuestRecordServiceServiceClient(address: ApiConfig().address).list(request) { response, _ in
            DispatchQueue.main.async {
                if AuthController.shared.fakeResponses {
                    self.fakeListReponse(completion: completion)
                } else {
                    completion(response?.questsRecords)
                }
            }
        }

        if call == nil {
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }

    private func fakeListReponse(completion: @escaping (_ records: [Sh_Generated_ShelterQuestRecord]?) -> Void) {
        var shelter = Sh_Generated_Shelter()
        shelter.coordinate.lat = 55.756683
        shelter.coordinate.lon = 37.622341
        shelter.iconName = "shelterIcon"

        var quest1 = Sh_Generated_ShelterQuest()
        quest1.order.tags = ["tag1"]
        quest1.order.title = "Катать собак на автомибиле"
        quest1.order.description_p = "Необходимо катать собак на автомобиле с открытм окном. Собаки будут высовывать голову из окна и язык из рта против ветра. Собаки будут счастливы"
        quest1.order.shelter = shelter
        var quest1_step1 = Sh_Generated_ShelterQuestStep()
        quest1_step1.demand.text = "Покатать собак"
        quest1.steps.append(quest1_step1)

        var quest2 = Sh_Generated_ShelterQuest()
        quest2.order.tags = ["tag2"]
        quest2.order.title = "Кидать говно в вальере"
        quest2.order.description_p = "Если ты устал на работе и хочешь покидать говно в вальере, то это преддложение для тебя. Лопату надо купить."
        quest2.order.shelter = shelter
        var quest2_step1 = Sh_Generated_ShelterQuestStep()
        quest2_step1.demand.id = 123
        quest2_step1.demand.text = "Купить лопату"
        var quest2_step2 = Sh_Generated_ShelterQuestStep()
        quest2_step2.demand.text = "Покидать говно"
        quest2.steps.append(quest2_step1)
        quest2.steps.append(quest2_step2)

        var questRecord1 = Sh_Generated_ShelterQuestRecord()
        questRecord1.shelterQuest = quest1
        questRecord1.status = .inProgress

        var questRecord2 = Sh_Generated_ShelterQuestRecord()
        questRecord2.shelterQuest = quest2
        questRecord2.status = .inProgress
        questRecord2.doneDemands = [123]

        var fakeResponse = Sh_Generated_ShelterQuestListReponse()
        fakeResponse.questsRecords.append(questRecord1)
        fakeResponse.questsRecords.append(questRecord2)

        completion(fakeResponse.questsRecords)
    }
}

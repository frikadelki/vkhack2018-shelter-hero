//
//  QuestsSearchController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 10.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation

class QuestsSearchController {

    enum Result {
        case success(quests: Sh_Generated_SearchQuestsResponse)
        case error(error: Error)
    }

    func search(request: Sh_Generated_SearchQuestsRequest, completion: @escaping (_ result: Result) -> Void) {

        let completionOnMainThread = { (result: Result) in
            if Thread.isMainThread {
                completion(result)
            } else {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }

        do {
            let _ = try Sh_Generated_QuestsServiceServiceClient(address: ApiConfig().address, secure: false).search(request) { response, callResult in
                if AuthController.shared.fakeResponses {
                    self.fakeResponse(request: request, completion: completionOnMainThread)
                } else if let response = response {
                    completionOnMainThread(.success(quests: response))
                } else {
                    completionOnMainThread(.error(error: NSError(domain: "QuestsSearchController.search", code: -1, userInfo: [
                        NSLocalizedDescriptionKey : callResult.description,
                        ]
                    )))
                }
            }
        }
        catch let exception {
            completionOnMainThread(.error(error: NSError(domain: "QuestsSearchController.search", code: -1, userInfo: [
                NSLocalizedDescriptionKey : exception.localizedDescription,
                ]
            )))
        }
    }

    private func fakeResponse(request: Sh_Generated_SearchQuestsRequest, completion: @escaping (_ result: Result) -> Void) {
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
        quest2.order.description_p = "Если ты устал на работе и хочегь покидать говно в вальере, то это преддложение для тебя. Лопату надо купить."
        quest2.order.shelter = shelter
        var quest2_step1 = Sh_Generated_ShelterQuestStep()
        quest2_step1.demand.text = "Купить лопату"
        var quest2_step2 = Sh_Generated_ShelterQuestStep()
        quest2_step2.demand.text = "Покидать говно"
        quest2.steps.append(quest2_step1)
        quest2.steps.append(quest2_step2)

        var fakeResponse = Sh_Generated_SearchQuestsResponse()
        if !Set(request.orderTags).intersection(Set(quest1.order.tags)).isEmpty || request.orderTags.isEmpty {
            fakeResponse.quests.append(quest1)
        }
        if !Set(request.orderTags).intersection(Set(quest2.order.tags)).isEmpty || request.orderTags.isEmpty {
            fakeResponse.quests.append(quest2)
        }

        DispatchQueue.global().async {
            completion(.success(quests: fakeResponse))
        }
    }
}

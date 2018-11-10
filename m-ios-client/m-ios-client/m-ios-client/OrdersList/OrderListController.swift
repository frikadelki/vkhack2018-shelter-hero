//
//  OrderListController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 10.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation

class OrderListController {

    enum Result {
        case success(orders: Sh_Generated_OrdersResponse)
        case error(error: Error)
    }

    func searchOrders(request: Sh_Generated_SearchOrdersRequest, completion: @escaping (_ result: Result) -> Void) {

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
            let _ = try Sh_Generated_OrderServiceServiceClient(address: ApiConfig().address).searchOrders(request) { response, callResult in
                if AuthController.shared.fakeResponses {
                    self.fakeResponse(request: request, completion: completionOnMainThread)
                } else if let response = response {
                    completionOnMainThread(.success(orders: response))
                } else {
                    completionOnMainThread(.error(error: NSError(domain: "OrderListController.searchOrders", code: -1, userInfo: [
                        NSLocalizedDescriptionKey : callResult.description,
                        ]
                    )))
                }
            }
        }
        catch let exception {
            completionOnMainThread(.error(error: NSError(domain: "OrderListController.searchOrders", code: -1, userInfo: [
                NSLocalizedDescriptionKey : exception.localizedDescription,
                ]
            )))
        }
    }

    private func fakeResponse(request: Sh_Generated_SearchOrdersRequest, completion: @escaping (_ result: Result) -> Void) {
        var shelter = Sh_Generated_Shelter()
        shelter.coordinate.lat = 55.756683
        shelter.coordinate.lon = 37.622341
        shelter.iconName = "shelterIcon"

        var task1 = Sh_Generated_Order()
        task1.tags = ["tag1"]
        task1.title = "Катать собак на автомибиле"
        task1.description_p = "Необходимо катать собак на автомобиле с открытм окном. Собаки будут высовывать голову из окна и язык из рта против ветра. Собаки будут счастливы"
        task1.shelter = shelter

        var task2 = Sh_Generated_Order()
        task2.tags = ["tag2"]
        task2.title = "Кидать говно в вальере"
        task2.description_p = "Если ты устал на работе и хочегь покидать говно в вальере, то это преддложение для тебя. Лопату предоставим."
        task2.shelter = shelter

        var fakeResponse = Sh_Generated_OrdersResponse()
        if !Set(request.orderTags).intersection(Set(task1.tags)).isEmpty || request.orderTags.isEmpty {
            fakeResponse.orders.append(task1)
        }
        if !Set(request.orderTags).intersection(Set(task2.tags)).isEmpty || request.orderTags.isEmpty {
            fakeResponse.orders.append(task2)
        }

        DispatchQueue.global().async {
            completion(.success(orders: fakeResponse))
        }
    }
}

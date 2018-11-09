//
//  MapController.swift
//  m-ios-client
//
//  Created by Denis Morozov on 09.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation

class MapController {

    enum Result {
        case success(mapObjects: Sh_Generated_MapObjectResponse)
        case error(error: Error)
    }

    func allObjects(completion: @escaping (_ result: Result) -> Void) {
        var request = Sh_Generated_MapObjectRequest()
        request.token = TokenProvider.shared.token

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
            let _ = try Sh_Generated_MapObjectServiceServiceClient(address: "").allObjects(request) { (response, callResult) in
                if TokenProvider.shared.fakeResponses {
                    self.fakeResponse(completion: completionOnMainThread)
                } else if let response = response {
                    completionOnMainThread(.success(mapObjects: response))
                } else {
                    completionOnMainThread(.error(error: NSError(domain: "MapController.allObjects", code: -1, userInfo: [
                        NSLocalizedDescriptionKey : callResult.description
                        ]
                    )))
                }
            }
        }
        catch let exeption {
            completionOnMainThread(.error(error: NSError(domain: "MapController.allObjects", code: -1, userInfo: [
                NSLocalizedDescriptionKey : exeption.localizedDescription
                ]
            )))
        }
    }

    private func fakeResponse(completion: @escaping (_ result: Result) -> Void) {
        var shelter1 = Sh_Generated_ShelterMapObject()
        shelter1.coordinate.latitude = 55.756683
        shelter1.coordinate.longitude = 37.622341
        shelter1.iconName = "shelterIcon"

        var task1 = Sh_Generated_MapObjectTask()
        task1.tags = ["tag1"]
        var task2 = Sh_Generated_MapObjectTask()
        task2.tags = ["tag2"]

        shelter1.availableTasks = [task1, task2]

        var shelter2 = Sh_Generated_ShelterMapObject()
        shelter2.coordinate.latitude = 55.776683
        shelter2.coordinate.longitude = 37.618341
        shelter2.iconName = "shelterIcon"
        shelter2.availableTasks = []

        var venue1 = Sh_Generated_VenueMapObject()
        venue1.coordinate.latitude = 55.770683
        venue1.coordinate.longitude = 37.610341
        venue1.iconName = "venue1"
        venue1.tags = ["veterinary clinic"]

        var fakeResponse = Sh_Generated_MapObjectResponse()
        fakeResponse.shelters = [shelter1, shelter2]
        fakeResponse.venues = [venue1]

        DispatchQueue.global().async {
            completion(.success(mapObjects: fakeResponse))
        }
    }
}

//
//  SessionProvider.swift
//  m-ios-client
//
//  Created by Denis Morozov on 09.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation

class AuthController {
    static let shared: AuthController = AuthController()

    private(set) var token: String = ""

    func regiter(login: String, password: String, completion: @escaping (_ susses: Bool) -> Void) {
        var request = Sh_Generated_AuthRequest()
        request.login = login
        request.password = password
        do {
            let _ = try Sh_Generated_AuthServiceServiceClient(address: ApiConfig().address, secure: false).register(request) { response, _ in
                if ApiConfig().fakeResponses {
                    self.token = "fake_token"
                    completion(true)
                } else if let response = response {
                    self.token = response.token
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        catch _ {
            completion(false)
        }
    }

    func login(login: String, password: String, completion: @escaping (_ susses: Bool) -> Void) {
        var request = Sh_Generated_AuthRequest()
        request.login = login
        request.password = password
        do {
            let _ = try Sh_Generated_AuthServiceServiceClient(address: ApiConfig().address, secure: false).login(request) { response, _ in
                if ApiConfig().fakeResponses {
                    self.token = "fake_token"
                    completion(true)
                } else if let response = response {
                    self.token = response.token
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        catch _ {
            completion(false)
        }
    }

    func logout(completion: @escaping () -> Void) {
        var request = Sh_Generated_LogoutRequest()
        request.token = token
        do {
            let _ = try Sh_Generated_AuthServiceServiceClient(address: ApiConfig().address, secure: false).logout(request) { _, _ in
                self.token = ""
                completion()
            }
        }
        catch _ {
            token = ""
            completion()
        }
    }
}

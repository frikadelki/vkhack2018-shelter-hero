//
//  SessionProvider.swift
//  m-ios-client
//
//  Created by Denis Morozov on 09.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import Foundation

protocol ITokenProvider {

    var token: String { get }
    var fakeResponses: Bool { get }

    func authorize(completion: () -> Void)
}

class TokenProvider: ITokenProvider {
    static let shared: ITokenProvider = TokenProvider()

    private(set) var token: String = ""

    let fakeResponses: Bool = true

    func authorize(completion: () -> Void) {
        //do authorize
    }
}

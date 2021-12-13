//
//  TopupRequest.swift
//  
//
//  Created on 2021/12/14.
//

import Foundation
import Network

struct TopupRequest: Request {
    typealias Output = TopupResponse

    var endpoint: URL
    var method: HTTPMethod
    var query: QueryItems
    var header: HTTPHeader
    
    init(baseURL: URL, amount: Double, paymentMethodModelID: String) {
        self.endpoint = baseURL.appendingPathComponent("/topup")
        self.method = .post
        self.query = [
            "amount": amount,
            "paymentMethodModelID": paymentMethodModelID
        ]
        self.header = [:]
    }
}

struct TopupResponse: Decodable {
    let status: String
}

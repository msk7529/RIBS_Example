//
//  TopupRequest.swift
//  
//
//  Created by aiden_h on 2021/12/15.
//

import Foundation
import Network

struct TopupRequest: Request {
    typealias Output = TopupResponse
    
    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeader
    
    init(baseURL: URL, amount: Double, paymentMethodId: String) {
        self.endpoint = baseURL.appendingPathComponent("/topup")
        self.method = .post
        self.query = [
            "amount": amount,
            "paymentMethodId": paymentMethodId
        ]
        self.header = [:]
    }
}

struct TopupResponse: Decodable {
    let status: String
}

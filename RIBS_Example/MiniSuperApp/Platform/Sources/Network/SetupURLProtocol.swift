//
//  SetupURLProtocol.swift
//  
//
//  Created on 2021/12/14.
//

import Foundation

public func setupURLProtocol() {
    let topupResponse: [String: Any] = [
        "status": "success"
    ]
    
    let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
    
    SuperAppURLProtocol.successMock = [
        "/api/v1/topup": (200, topupResponseData)
    ]
}

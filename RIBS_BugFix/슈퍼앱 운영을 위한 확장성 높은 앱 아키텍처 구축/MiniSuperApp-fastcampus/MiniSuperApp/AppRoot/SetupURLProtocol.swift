//
//  SetupURLProtocol.swift
//  MiniSuperApp
//
//  Created by aiden_h on 2021/12/15.
//

import Foundation

func setupURLProtocol() {
    let topupResponse: [String: Any]  = [
        "status": "ssuccess"
    ]
    
    let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
    
    let addCardResponse: [String: Any] = [
        "card": [
            "id": "999",
            "name": "새 카드",
            "digits": "**** 0101",
            "color": "",
            "isPrimary": false
        ]
    ]
    
    let addCardResponseData = try! JSONSerialization.data(withJSONObject: addCardResponse, options: [])
    
    let cardOnFilesResponse: [String: Any] = [
        "cards": [
            [
                "id": "0",
                "name": "우리은행",
                "digits": "0123",
                "color": "#f19a38ff",
                "isPrimary": false
            ],
            [
                "id": "1",
                "name": "신한카드",
                "digits": "0987",
                "color": "#3478f6ff",
                "isPrimary": false
            ],
            [
                "id": "2",
                "name": "현대카드",
                "digits": "8121",
                "color": "#78c5f5ff",
                "isPrimary": false
            ]
        ]
    ]
    
    let cardOnFilesResponseData = try! JSONSerialization.data(withJSONObject: cardOnFilesResponse, options: [])
    
    
    SuperAppURLProtocol.successMock = [
        "/api/v1/topup": (200, topupResponseData),
        "/api/v1/addCard": (200, addCardResponseData),
        "/api/v1/cards": (200, cardOnFilesResponseData)
    ]
}

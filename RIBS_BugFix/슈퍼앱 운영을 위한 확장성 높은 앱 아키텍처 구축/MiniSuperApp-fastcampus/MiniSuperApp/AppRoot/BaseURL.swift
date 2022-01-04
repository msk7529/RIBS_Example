//
//  BaseURL.swift
//  MiniSuperApp
//
//  Created by aiden_h on 2021/12/15.
//

import Foundation

struct BaseURL {
    var financeBaseURL: URL {
        #if UITESTING
        return URL(string: "http://localhost:8080")!
        #else
        return URL(string: "https://finance.superpay.com/api/v1")!
        #endif
    }
}

//
//  BaseURL.swift
//  MiniSuperApp
//
//  Created on 2021/12/14.
//
// AppRoot에 들어가야 하는데, 모듈화를 덜 해서 이쪽에 구현

import Foundation


public struct BaseURL {
    public var financeBaseURL: URL {
        return URL(string: "https://finance.superapp.com/api/v1")!
    }
    
    public init() { }
}

//
//  PaymentMethodModel.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/10/27.
//

import Foundation

public struct PaymentMethodModel: Decodable {
    public let id: String
    public let name: String
    public let digits: String
    public let color: String
    public let isPrimary: Bool
    
    // public으로 접근자를 바꾸면, 기본 이니셔라이저가 제공되지 않아 수동으로 만들어주어야 한다.
    public init(id: String, name: String, digits: String, color: String, isPrimary: Bool) {
        self.id = id
        self.name = name
        self.digits = digits
        self.color = color
        self.isPrimary = isPrimary
    }
}

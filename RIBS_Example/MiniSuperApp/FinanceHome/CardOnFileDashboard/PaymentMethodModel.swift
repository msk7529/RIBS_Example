//
//  PaymentMethodModel.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/10/27.
//

import Foundation

struct PaymentMethodModel: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}

//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/10/27.
//

import UIKit

struct PaymentMethodViewModel {
    let name: String
    let digits: String
    let color: UIColor
    
    init(_ paymentMethod: PaymentMethodModel) {
        name = paymentMethod.name
        digits = "**** \(paymentMethod.digits)"
        color = UIColor(hex: paymentMethod.color) ?? .systemGray
    }
}

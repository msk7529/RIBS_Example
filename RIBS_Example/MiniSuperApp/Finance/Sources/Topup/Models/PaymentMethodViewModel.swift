//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created on 2021/10/27.
//

import FinanceEntity
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

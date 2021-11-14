//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/10/27.
//

import Foundation
import Combine

protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethodModel]> { get }
    
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethodModel, Error>
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
    private let paymentMethodSubject = CurrentValuePublisher<[PaymentMethodModel]>([
        PaymentMethodModel(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
        PaymentMethodModel(id: "1", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
        PaymentMethodModel(id: "2", name: "현대카드", digits: "8121", color: "#78c5f5ff", isPrimary: false),
//        PaymentMethodModel(id: "3", name: "국민은행", digits: "2812", color: "#65c466ff", isPrimary: false),
//        PaymentMethodModel(id: "4", name: "카카오뱅크", digits: "8751", color: "#ffcc00ff", isPrimary: false)
    ])
    
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethodModel]> {
        return paymentMethodSubject
    }
    
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethodModel, Error> {
        let paymentMethodModel = PaymentMethodModel(id: "00", name: "New 카드", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)
        
        var new = paymentMethodSubject.value
        new.append(paymentMethodModel)
        paymentMethodSubject.send(new)
        
        return Just(paymentMethodModel).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

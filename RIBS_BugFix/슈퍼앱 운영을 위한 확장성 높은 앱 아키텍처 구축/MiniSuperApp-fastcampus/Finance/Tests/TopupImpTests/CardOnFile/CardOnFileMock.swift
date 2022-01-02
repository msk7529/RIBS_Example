//
//  CardOnFileMock.swift
//  
//
//  Created on 2022/01/03.
//

import Foundation
import FinanceEntity
import RIBsTestSupport
@testable import TopupImp

final class CardOnFileBuildableMock: CardOnFileBuildable {
    
    var buildHandler: ((_ listener: CardOnFileListener) -> CardOnFileRouting)?
    var buildCallCount: Int = 0
    var buildPaymentMethods: [PaymentMethod]?
    func build(withListener listener: CardOnFileListener, paymentMethod: [PaymentMethod]) -> CardOnFileRouting {
        buildCallCount += 1
        buildPaymentMethods = paymentMethod

        if let buildHandler = buildHandler {
            return buildHandler(listener)
        }
        fatalError()
    }
}

final class CardOnFileRoutingMock: ViewableRoutingMock, CardOnFileRouting {
    
}

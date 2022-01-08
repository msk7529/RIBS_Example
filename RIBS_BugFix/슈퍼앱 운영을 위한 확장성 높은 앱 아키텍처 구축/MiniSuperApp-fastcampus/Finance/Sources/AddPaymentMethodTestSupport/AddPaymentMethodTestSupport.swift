//
//  AddPaymentMethodTestSupport.swift
//  
//
//  Created on 2021/12/29.
//

import AddPaymentMethod
import Foundation
import ModernRIBs
import RIBsUtil
import RIBsTestSupport
import FinanceEntity

public final class AddPaymentMethodBuildableMock: AddPaymentMethodBuildable {
    
    public var buildCallCount: Int = 0
    public var closeButtonType: DismissButtonType?
    public func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting {
        buildCallCount += 1
        self.closeButtonType = closeButtonType
        
        return ViewableRoutingMock(interactable: Interactor(), viewControllable: ViewControllableMock())
    }
    
    public init() { }

}

public final class AddPaymentMethodListenerMock: AddPaymentMethodListener {
    
    public init() { }
    
    public var addPaymentMethodDidTapCloseCallCount: Int = 0
    public func addPaymentMethodDidTapClose() {
        addPaymentMethodDidTapCloseCallCount += 1
    }
    
    public var addPaymentMethodDidAddCardCallCount: Int = 0
    public var addPaymentMethodDidAddCardPaymentMethod: PaymentMethod?
    public func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        addPaymentMethodDidAddCardCallCount += 1
        addPaymentMethodDidAddCardPaymentMethod = paymentMethod
    }
}

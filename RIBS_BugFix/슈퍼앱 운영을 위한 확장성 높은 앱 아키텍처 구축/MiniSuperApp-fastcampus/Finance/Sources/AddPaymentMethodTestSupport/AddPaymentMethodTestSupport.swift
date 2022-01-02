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

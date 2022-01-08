//
//  AddPaymentMethodIntegrationTests.swift
//  AddPaymentMethodIntegrationTests
//
//  Created by kakao on 2022/01/09.
//
// IntegratoinTest. UI Test와 Unit Text의 혼합버전 느낌 ..?

import AddPaymentMethodTestSupport
import Hammer
import XCTest
import FinanceEntity
import FinanceRepository
import FinanceRepositoryTestSupport
import ModernRIBs
import RIBsUtil
@testable import AddPaymentMethodImp

class AddPaymentMethodIntegrationTests: XCTestCase {

    private var eventGenerator: EventGenerator!
    private var dependency: AddPaymentMethodDependencyMock!
    private var listener: AddPaymentMethodListenerMock!
    private var viewController: UIViewController!
    private var router: Routing!
    
    private var repository: CardOnFileRepositoryMock {
        dependency.cardOnFileRepository as! CardOnFileRepositoryMock
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.dependency = AddPaymentMethodDependencyMock()
        self.listener = AddPaymentMethodListenerMock()
        
        let builder = AddPaymentMethodBuilder(dependency: self.dependency)
        let router = builder.build(withListener: self.listener, closeButtonType: .close)
        
        let navigation = NavigationControllerable(root: router.viewControllable)
        self.viewController = navigation.uiviewController
        
        eventGenerator = try EventGenerator(viewController: navigation.navigationController)
        
        router.load()
        router.interactable.activate()
        
        self.router = router
    }
    
    func testAddPaymentMethod() throws {
        // given
        repository.addedPaymentMethod = PaymentMethod(id: "1234", name: "", digits: "", color: "", isPrimary: false)
        
        let cardNumberTF = try eventGenerator.viewWithIdentifier("addpaymentmethod_cardnumber_textfield")
        try eventGenerator.fingerTap(at: cardNumberTF)
        try eventGenerator.keyType("123412312312312")
        
        let cvc = try eventGenerator.viewWithIdentifier("addpaymentmethod_security_textfield")
        try eventGenerator.fingerTap(at: cvc)
        try eventGenerator.keyType("123")
        
        let expiry = try eventGenerator.viewWithIdentifier("addpaymentmethod_expiry_textfield")
        try eventGenerator.fingerTap(at: expiry)
        try eventGenerator.keyType("1212")
        
        // when
        let confirm = try eventGenerator.viewWithIdentifier("addpaymentmethod_addcard_button")
        try eventGenerator.fingerTap(at: confirm)
        
        // then
        XCTAssertEqual(repository.addCardCallCount, 1)
        try eventGenerator.wait(0.2)    // didTapConfirm 메서드에서 메인큐 비동기 로직이 들어있어, wait을 걸어준다.
        XCTAssertEqual(listener.addPaymentMethodDidAddCardCallCount, 1)
        XCTAssertEqual(listener.addPaymentMethodDidAddCardPaymentMethod?.id, "1234")
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

final class AddPaymentMethodDependencyMock: AddPaymentMethodDependency {
    var cardOnFileRepository: CardOnFileRepository = CardOnFileRepositoryMock()
    
    
}

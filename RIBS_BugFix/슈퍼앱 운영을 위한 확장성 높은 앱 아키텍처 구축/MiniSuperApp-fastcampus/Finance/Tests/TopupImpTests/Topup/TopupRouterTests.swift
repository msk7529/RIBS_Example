//
//  TopupRouterTests.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/12/28.
//

@testable import TopupImp
import AddPaymentMethodTestSupport
import ModernRIBs
import RIBsTestSupport
import XCTest

final class TopupRouterTests: XCTestCase {

    private var sut: TopupRouter!
    private var interactor: TopupInteractableMock!
    private var viewController: ViewControllableMock!
    private var addPaymentMethodBuildable: AddPaymentMethodBuildableMock!
    private var enterAmountBuildable: EnterAmountBuildableMock!
    private var cardOnFileBuildable: CardOnFileBuildableMock!

    override func setUp() {
        super.setUp()

        interactor = TopupInteractableMock()
        viewController = ViewControllableMock()
        addPaymentMethodBuildable = AddPaymentMethodBuildableMock()
        enterAmountBuildable = EnterAmountBuildableMock()
        cardOnFileBuildable = .init()
        
        sut = TopupRouter(interactor: interactor, viewController: viewController, addPaymentMethodBuildable: addPaymentMethodBuildable, enterAmountBuildable: enterAmountBuildable, cardOnFileBuildable: cardOnFileBuildable)
    }

    // MARK: - Tests

    func testAttachAddPaymentMethod() {
        // given
        
        // when
        sut.attachAddPaymentMethod(closeButtonType: .close)
        
        // then
        XCTAssertEqual(addPaymentMethodBuildable.buildCallCount, 1)
        XCTAssertEqual(addPaymentMethodBuildable.closeButtonType, .close)
        XCTAssertEqual(viewController.presentCallCount, 1)
    }
    
    func testAttachEnterAmount() {
        // given
        let router = EnterAmountRoutingMock(interactable: Interactor(), viewControllable: ViewControllableMock())
        
        var assignedLister: EnterAmountListener?
        enterAmountBuildable.buildHandler = { listener in
            assignedLister = listener
            return router
        }
        
        // when
        sut.attachEnterAmount()
        
        // then
        XCTAssertTrue(assignedLister === interactor)
        XCTAssertEqual(enterAmountBuildable.buildCallCount, 1)
    }
    
    func testAttachEnterAmountOnNavigation() {
        // given
        let router = EnterAmountRoutingMock(interactable: Interactor(), viewControllable: ViewControllableMock())
        
        var assignedLister: EnterAmountListener?
        enterAmountBuildable.buildHandler = { listener in
            assignedLister = listener
            return router
        }
        
        // when
        sut.attachAddPaymentMethod(closeButtonType: .close)
        sut.attachEnterAmount()
        
        
        // then
        XCTAssertTrue(assignedLister === interactor)
        XCTAssertEqual(enterAmountBuildable.buildCallCount, 1)
        XCTAssertEqual(viewController.presentCallCount, 1)
        XCTAssertEqual(sut.children.count, 1)
    }
}

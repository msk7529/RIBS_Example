//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/12/27.
//

@testable import TopupImp
import FinanceEntity
import XCTest
import FinanceRepositoryTestSupport

final class EnterAmountInteractorTests: XCTestCase {

    private var sut: EnterAmountInteractor!     // system under test. 검증대상이 되는 객체의 변수명
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    private var listener: EnterAmountListenerMock!
    
    private var repository: SuperPayRepositoryMock! {
        return dependency.superPayRepository as? SuperPayRepositoryMock
    }
    
    // TODO: declare other objects and mocks you need as private vars

    override func setUp() {
        super.setUp()

        // TODO: instantiate objects and mocks
        
        self.presenter = EnterAmountPresentableMock()
        self.dependency = EnterAmountDependencyMock()
        self.listener = EnterAmountListenerMock()
        
        sut = .init(presenter: self.presenter, dependecy: self.dependency)
        sut.listener = self.listener
    }

    // MARK: - Tests

    // 유닛테스트의 함수명은 반드시 test로 시작해야한다.
    func testActivate() {
        // given
        let paymentMethod = PaymentMethod(id: "id_0", name: "name_0", digits: "9999", color: "#13ABE8FF", isPrimary: false)
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when. 검증하고자 하는 행위
        sut.activate()
        
        // then. 예상한 행동을 했는지
        XCTAssertEqual(presenter.updateSelectedPaymentMethodCallCount, 1)
        XCTAssertEqual(presenter.updateSelectedPaymentMethodViewModel?.name, "name_0 9999")
        XCTAssertNotNil(presenter.updateSelectedPaymentMethodViewModel?.image)
    }
    
    func testTopupWithValidAmount() {
        // given
        let paymentMethod = PaymentMethod(id: "id_0", name: "name_0", digits: "9999", color: "#13ABE8FF", isPrimary: false)
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when
        sut.didTapTopup(with: 1000000)
        
        // then
        //_ = XCTWaiter.wait(for: [expectation(description: "Wait 0.1 second")], timeout: 0.1)
        // Combine Scheduler(.immediate)를 사용함으로써 동기적으로 코드가 실행될 수 있도록 하여, 위 코드를 제거할 수 있다. 매 테스트시마다 동일한 결과를 얻을 수 있음
        XCTAssertEqual(presenter.startLoadingCallCount, 1)
        XCTAssertEqual(presenter.stopLoadingCallCount, 1)
        XCTAssertEqual(repository.topupCallCount, 1)
        XCTAssertEqual(repository.paymentMethodID, "id_0")
        XCTAssertEqual(repository.topupAmount, 1000000)
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 1)
    }
}

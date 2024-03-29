//
//  File.swift
//  
//
//  Created by kakao on 2021/12/27.
//

import CombineUtil
import CombineSchedulers
import Foundation
import FinanceEntity
import FinanceRepository
import FinanceRepositoryTestSupport
import RIBsTestSupport
@testable import TopupImp

final class EnterAmountPresentableMock: EnterAmountPresentable {
    
    var listener: EnterAmountPresentableListener?
    
    var updateSelectedPaymentMethodCallCount: Int = 0
    var updateSelectedPaymentMethodViewModel: SelectedPaymentMethodViewModel?
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel) {
        updateSelectedPaymentMethodCallCount += 1
        updateSelectedPaymentMethodViewModel = viewModel
    }
    
    var startLoadingCallCount: Int = 0
    func startLoading() {
        startLoadingCallCount += 1
    }
    
    var stopLoadingCallCount: Int = 0
    func stopLoading() {
        stopLoadingCallCount += 1
    }
    
    init() { }
}


final class EnterAmountDependencyMock: EnterAmountInteractorDependency {
    
    var selectedPaymentMethodSubject = CurrentValuePublisher<PaymentMethod>(
        PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false)
    )
    
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> {
        return selectedPaymentMethodSubject
    }
    
    var superPayRepository: SuperPayRepository = SuperPayRepositoryMock()
    
    var mainQueue: AnySchedulerOf<DispatchQueue> {
        return .immediate   // 테스트시에는 immediate큐를 넣어준다. 동기적으로 실행될 수 있도록
    }
}

final class EnterAmountListenerMock: EnterAmountListener {
    
    var enterAmountDidTapCloseCallCount: Int = 0
    func enterAmountDidTapClose() {
        enterAmountDidTapCloseCallCount += 1
    }
    
    var enterAmountDidTapPaymentMethodCallCount: Int = 0
    func enterAmountDidTapPaymentMethod() {
        enterAmountDidTapPaymentMethodCallCount += 1
    }
    
    var enterAmountDidFinishTopupCallCount: Int = 0
    func enterAmountDidFinishTopup() {
        enterAmountDidFinishTopupCallCount += 1
    }
}

final class EnterAmountBuildableMock: EnterAmountBuildable {
    
    var buildHandler: ((_ listener: EnterAmountListener) -> EnterAmountRouting)?
    var buildCallCount: Int = 0
    
    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
        buildCallCount += 1
        
        if let buildHandler = buildHandler {
            return buildHandler(listener)
        }
        fatalError()
    }
}

final class EnterAmountRoutingMock: ViewableRoutingMock, EnterAmountRouting {
    
}


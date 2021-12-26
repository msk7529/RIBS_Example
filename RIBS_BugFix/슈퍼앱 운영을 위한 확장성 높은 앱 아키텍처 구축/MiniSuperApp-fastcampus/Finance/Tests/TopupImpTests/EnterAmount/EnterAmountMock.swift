//
//  File.swift
//  
//
//  Created by kakao on 2021/12/27.
//

import Foundation
import FinanceEntity
import FinanceRepository
import FinanceRepositoryTestSupport
import CombineUtil
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
}

final class EnterAmountListenerMock: EnterAmountListener {
    
    var enterAmountDidTapCloseCallCount: Int = 0
    func enterAmountDidTapClose() {
        enterAmountDidTapCloseCallCount += 1
    }
    
    var enterAmountDidTapPaymentMehoedCallCount: Int = 0
    func enterAmountDidTapPaymentMehoed() {
        enterAmountDidTapPaymentMehoedCallCount += 1
    }
    
    var enterAmountDidFinishTopupCallCount: Int = 0
    func enterAmountDidFinishTopup() {
        enterAmountDidFinishTopupCallCount += 1
    }
    
    
}


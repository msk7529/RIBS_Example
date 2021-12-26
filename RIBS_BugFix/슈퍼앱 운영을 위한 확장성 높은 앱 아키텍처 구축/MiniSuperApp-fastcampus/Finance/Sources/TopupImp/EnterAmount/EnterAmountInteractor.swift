//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by aiden_h on 2021/11/16.
//

import Foundation
import ModernRIBs
import Combine
import CombineUtil
import FinanceEntity
import FinanceRepository

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
    func startLoading()
    func stopLoading()
}

protocol EnterAmountListener: AnyObject {
    func enterAmountDidTapClose()
    func enterAmountDidTapPaymentMehoed()
    func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency {
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
    var superPayRepository: SuperPayRepository { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {

    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?
    
    private let dependency: EnterAmountInteractorDependency
    
    private var cancelable: Set<AnyCancellable> = .init()

    init(
        presenter: EnterAmountPresentable,
        dependecy: EnterAmountInteractorDependency
    ) {
        self.dependency = dependecy
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.selectedPaymentMethod.sink { [weak self] paymentMethod in
            self?.presenter.updateSelectedPaymentMethod(with: .init(paymentMethod))
        }.store(in: &cancelable)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.enterAmountDidTapClose()
    }
    
    func didTapPaymentMethod() {
        listener?.enterAmountDidTapPaymentMehoed()
    }
    
    func didTapTopup(with amount: Double) {
        presenter.startLoading()
        
        dependency.superPayRepository
            .topup(
                amount: amount,
                paymentMethodID: dependency.selectedPaymentMethod.value.id
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.presenter.stopLoading()
                },
                receiveValue: { [weak self] _ in
                    self?.listener?.enterAmountDidFinishTopup()
                }
            )
            .store(in: &cancelable)
    }
}

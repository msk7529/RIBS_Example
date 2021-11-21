//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/11/15.
//

import ModernRIBs
import Combine
import Foundation

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
    func startLoading()
    func stopLoading()
}

protocol EnterAmountListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func enterAmountDidTapClose()
    func enterAmountDidTapPaymentMethod()
    func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency {
    var selectedPaymentMethodModel: ReadOnlyCurrentValuePublisher<PaymentMethodModel> { get }
    var superPayRepository: SuperPayRepository { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {

    private let dependency: EnterAmountInteractorDependency
    
    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?
    
    private var cancellables: Set<AnyCancellable> = .init()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: EnterAmountPresentable, dependency: EnterAmountInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        dependency.selectedPaymentMethodModel.sink { [weak self] paymentMethodModel in
            self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel.init(paymentMethodModel))
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.enterAmountDidTapClose()
    }
    
    func didTapPaymentMethod() {
        listener?.enterAmountDidTapPaymentMethod()
    }
    
    func didTapTopup(with amount: Double) {
        presenter.startLoading()
        
        dependency.superPayRepository.topup(amount: amount, paymentMethodID: dependency.selectedPaymentMethodModel.value.id)
            .receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] _ in
                self?.presenter.stopLoading()
            } receiveValue: { [weak self] _ in
                self?.listener?.enterAmountDidFinishTopup()
            }.store(in: &cancellables)
    }
    
}

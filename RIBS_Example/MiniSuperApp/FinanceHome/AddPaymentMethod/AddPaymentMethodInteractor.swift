//
//  AddPaymentMethodInteractor.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/11/08.
//

import ModernRIBs
import Combine

protocol AddPaymentMethodRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddPaymentMethodPresentable: Presentable {
    var listener: AddPaymentMethodPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AddPaymentMethodInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

protocol AddPaymentMethodListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func addPaymentMethodDidTapClose()
    func addPaymentMethodDidAddCard(paymentMethodModel: PaymentMethodModel)
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable>, AddPaymentMethodInteractable, AddPaymentMethodPresentableListener {

    weak var router: AddPaymentMethodRouting?
    weak var listener: AddPaymentMethodListener?
    
    private let dependency: AddPaymentMethodInteractorDependency
    
    private var cancellables: Set<AnyCancellable> = .init()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: AddPaymentMethodPresentable, dependency: AddPaymentMethodInteractorDependency) {
        self.dependency = dependency

        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapConfirm(with number: String, cvc: String, expiry: String) {
        let info = AddPaymentMethodInfo(number: number, cvc: cvc, expiration: expiry)
        dependency.cardsOnFileRepository.addCard(info: info)
            .sink { _ in
            } receiveValue: { [weak self] method in
                self?.listener?.addPaymentMethodDidAddCard(paymentMethodModel: method)
            }.store(in: &cancellables)
    }
    
    func didTapClose() {
        listener?.addPaymentMethodDidTapClose()
    }
}

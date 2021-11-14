//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/11/15.
//

import ModernRIBs

protocol CardOnFileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
    var listener: CardOnFilePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func cardOnFileDidTapClose()
    func cardOnFileDidTapAddCard()
    func cardOnFileDidSelect(at index: Int)
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {

    private let paymentMethodModel: [PaymentMethodModel]
    
    weak var router: CardOnFileRouting?
    weak var listener: CardOnFileListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: CardOnFilePresentable, paymentMethodModel: [PaymentMethodModel]) {
        self.paymentMethodModel = paymentMethodModel
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        presenter.update(with: paymentMethodModel.map { PaymentMethodViewModel.init($0) })
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.cardOnFileDidTapClose()
    }
    
    func didSelectItem(at index: Int) {
        if index >= paymentMethodModel.count {
            listener?.cardOnFileDidTapAddCard()
        } else {
            listener?.cardOnFileDidSelect(at: index)
        }
    }
}

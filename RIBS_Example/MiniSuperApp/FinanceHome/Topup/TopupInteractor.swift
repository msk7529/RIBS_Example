//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/11/15.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
    func attachEnterAmount()
    func detachEnterAmout()
    func attachCardOnFile(paymentMethodModel: [PaymentMethodModel])
    func detachCardOnFile()
}

protocol TopupListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func topupDidClose()
    func topupDidFinish()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var paymentMethodModelStream: CurrentValuePublisher<PaymentMethodModel> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {
    
    private var paymentMethodModel: [PaymentMethodModel] {
        return dependency.cardOnFileRepository.cardOnFile.value
    }

    private let dependency: TopupInteractorDependency
    
    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    init(dependency: TopupInteractorDependency) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
            // 금액 입력 화면
            dependency.paymentMethodModelStream.send(card)
            router?.attachEnterAmount()
        } else {
            // 카드 추가 화면
            router?.attachAddPaymentMethod()
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        listener?.topupDidClose()
    }
    
    func presentationControllerDidDismiss() {
        router?.detachAddPaymentMethod()
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(paymentMethodModel: PaymentMethodModel) {
        
    }
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmout()
        listener?.topupDidClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(paymentMethodModel: paymentMethodModel)
    }
    
    func enterAmountDidFinishTopup() {
        listener?.topupDidFinish()
    }
    
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        // attach add card
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethodModel[safe: index] {
            dependency.paymentMethodModelStream.send(selected)
        }
        router?.detachCardOnFile()
    }
}

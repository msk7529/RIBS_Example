//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/11/15.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    func attachAddPaymentMethod(closeButtonType: DismissButtonType)
    func detachAddPaymentMethod()
    func attachEnterAmount()
    func detachEnterAmout()
    func attachCardOnFile(paymentMethodModel: [PaymentMethodModel])
    func detachCardOnFile()
    func popToRoot()
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
    
    private var isEnterAmountRoot: Bool = false
    
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
            isEnterAmountRoot = true
            dependency.paymentMethodModelStream.send(card)
            router?.attachEnterAmount()
        } else {
            // 카드 추가 화면
            isEnterAmountRoot = false
            router?.attachAddPaymentMethod(closeButtonType: .close)
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        if !isEnterAmountRoot {
            listener?.topupDidClose()
        }
    }
    
    func presentationControllerDidDismiss() {
        router?.detachAddPaymentMethod()
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(paymentMethodModel: PaymentMethodModel) {
        dependency.paymentMethodModelStream.send(paymentMethodModel)
        
        if isEnterAmountRoot {
            router?.popToRoot()
        } else {
            isEnterAmountRoot = true
            router?.attachEnterAmount()
        }
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
        router?.attachAddPaymentMethod(closeButtonType: .back)
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethodModel[safe: index] {
            dependency.paymentMethodModelStream.send(selected)
        }
        router?.detachCardOnFile()
    }
}

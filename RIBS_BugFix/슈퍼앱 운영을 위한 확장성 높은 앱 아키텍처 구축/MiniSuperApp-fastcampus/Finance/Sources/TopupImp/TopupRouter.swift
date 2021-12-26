//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by aiden_h on 2021/11/16.
//

import ModernRIBs
import AddPaymentMethod
import FinanceEntity
import SuperUI
import RIBsUtil
import Topup

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
    
    var presentationDelegateProxy : AdaptivePresentationControllerDelegateProxy { get }
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
    
    private var navigationControllerable: NavigationControllerable?

    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentRouting: Routing?
    
    private let enterAmountBuildable: EnterAmountBuildable
    private var enterAmountRouting: Routing?
    
    private let cardOnFileBuildable: CardOnFileBuildable
    private var cardOnFileRouting: Routing?
    
    init(
        interactor: TopupInteractable,
        viewController: ViewControllable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        enterAmountBuildable: EnterAmountBuildable,
        cardOnFileBuildable: CardOnFileBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.enterAmountBuildable = enterAmountBuildable
        self.cardOnFileBuildable = cardOnFileBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllerable != nil {
            navigationControllerable?.dismiss(completion: nil)
        }
    }
    
    func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
        guard addPaymentRouting == nil else {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)
        
        if let navigation = navigationControllerable {
            navigation.pushViewController(router.viewControllable, animated: true)
        } else {
            presentInsideNavigation(router.viewControllable)
        }
        
        addPaymentRouting = router
        attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        guard let routing = addPaymentRouting else {
            return
        }
        
        navigationControllerable?.popViewController(animated: true)
        
        detachChild(routing)
        addPaymentRouting = nil
    }
    
    func attachEnterAmount() {
        guard enterAmountRouting == nil else {
            return
        }
        
        let router = enterAmountBuildable.build(withListener: interactor)
        
        if let navigation = navigationControllerable {
            navigation.setViewControllers([router.viewControllable])
            resetChildRouting()
        } else {
            presentInsideNavigation(router.viewControllable)
        }
        
        enterAmountRouting = router
        attachChild(router)
    }
    
    func detachEnterAmount() {
        guard let routing = enterAmountRouting else {
            return
        }
        
        dismissPresentedNavigation(completion: nil)
        
        detachChild(routing)
        enterAmountRouting = nil
    }
    
    func attachCardOnFile(paymentMethods: [PaymentMethod]) {
        guard cardOnFileRouting == nil else {
            return
        }
        
        let router = cardOnFileBuildable.build(withListener: interactor, paymentMethod: paymentMethods)
        navigationControllerable?.pushViewController(router.viewControllable, animated: true)
        
        cardOnFileRouting = router
        attachChild(router)
    }
    
    func detachCardOnFile() {
        guard let routing = cardOnFileRouting else {
            return
        }
        
        navigationControllerable?.popViewController(animated: true)
        
        detachChild(routing)
        cardOnFileRouting = nil
    }
    
    func popToRoot() {
        navigationControllerable?.popToRoot(animated: true)
        resetChildRouting()
    }
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.navigationControllerable = navigation
        viewController.present(navigation, animated: true, completion: nil)
    }

    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllerable == nil {
            return
        }
        
        viewController.dismiss(completion: completion)
        self.navigationControllerable = nil
    }
    
    private func resetChildRouting() {
        if let routing = addPaymentRouting {
            detachChild(routing)
            addPaymentRouting = nil
        }
        
        if let routing = cardOnFileRouting {
            detachChild(routing)
            cardOnFileRouting = nil
        }
    }
    
    // MARK: - Private

    private let viewController: ViewControllable
}

import ModernRIBs
import SuperUI
import AddPaymentMethod
import Topup
import RIBsUtil

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    private let superPayDashboardBuildable: SuperPayDashboardBuildable
    private var superPayRouting: Routing?
    
    private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
    private var cardOnFileyRouting: Routing?
    
    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentRouting: Routing?
    
    private let topupBuildable: TopupBuildable
    private var topupRouting: Routing?

    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuildable: SuperPayDashboardBuildable,
        cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        topupBuildable: TopupBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.topupBuildable = topupBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - SpuerPayDashbaord
    func attachSpuerPayDashbaord() {
        guard superPayRouting == nil else {
            return
        }
        
        let router = superPayDashboardBuildable.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        superPayRouting = router
        attachChild(router)
    }
    
    // MARK: - CardOnFileDashbaord
    func attachCardOnFileDashbaord() {
        guard cardOnFileyRouting == nil else {
            return
        }
        
        let router = cardOnFileDashboardBuildable.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        cardOnFileyRouting = router
        attachChild(router)
    }
    
    // MARK: - AddPaymentMethod
    func attachAddPaymentMethod() {
        guard addPaymentRouting == nil else {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: .close)
        
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewControllable.present(navigation, animated: true, completion: nil)
        
        addPaymentRouting = router 
        attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        guard let routing = addPaymentRouting else {
            return
        }
        
        viewControllable.dismiss(completion: nil)
        
        detachChild(routing)
        addPaymentRouting = nil
    }
    
    func attachTopup() {
        guard topupRouting == nil else {
            return
        }
        
        let router = topupBuildable.build(withListener: interactor)
        
        topupRouting = router
        attachChild(router)
    }
    
    func detachTopup() {
        guard let routing = topupRouting else {
            return
        }
        
        detachChild(routing)
        topupRouting = nil
    }
}

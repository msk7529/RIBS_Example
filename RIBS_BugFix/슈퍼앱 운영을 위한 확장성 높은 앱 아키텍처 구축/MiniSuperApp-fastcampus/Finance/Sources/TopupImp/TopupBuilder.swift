//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by aiden_h on 2021/11/16.
//

import ModernRIBs
import FinanceRepository
import CombineUtil
import CombineSchedulers
import FinanceEntity
import AddPaymentMethod
import Topup

public protocol TopupDependency: Dependency {
    var topupBaseViewController: ViewControllable { get }
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
    var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, EnterAmountDependency, CardOnFileDependency {
    
    fileprivate var topupBaseViewController: ViewControllable {
        return dependency.topupBaseViewController
    }
    
    var cardOnFileRepository: CardOnFileRepository {
        dependency.cardOnFileRepository
    }
    
    var superPayRepository: SuperPayRepository {
        dependency.superPayRepository
    }
    
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable
    }
    
    var mainQueue: AnySchedulerOf<DispatchQueue> {
        dependency.mainQueue
    }
    
    let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> {
        return paymentMethodStream
    }
    
    init(
        dependency: TopupDependency,
        paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    ) {
        self.paymentMethodStream = paymentMethodStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    public override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TopupListener) -> Routing {
        let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
        
        let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
        let enterAmountBuiler = EnterAmountBuilder(dependency: component)
        let cardOnFileBuiler = CardOnFileBuilder(dependency: component)
        
        return TopupRouter(
            interactor: interactor,
            viewController: component.topupBaseViewController,
            addPaymentMethodBuildable: component.addPaymentMethodBuildable,
            enterAmountBuildable: enterAmountBuiler,
            cardOnFileBuildable: cardOnFileBuiler
        )
    }
}

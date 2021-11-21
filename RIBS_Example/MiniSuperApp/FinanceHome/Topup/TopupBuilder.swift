//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/11/15.
//

import ModernRIBs

protocol TopupDependency: Dependency {
    var topupBaseViewController: ViewControllable { get }
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
    let paymentMethodModelStream: CurrentValuePublisher<PaymentMethodModel>
    
    var cardOnFileRepository: CardOnFileRepository {
        return dependency.cardOnFileRepository
    }
    
    var superPayRepository: SuperPayRepository {
        return dependency.superPayRepository
    }
    
    fileprivate var topupBaseViewController: ViewControllable {
        return dependency.topupBaseViewController
    }
    
    var selectedPaymentMethodModel: ReadOnlyCurrentValuePublisher<PaymentMethodModel> {
        return paymentMethodModelStream
    }
    
    init(dependency: TopupDependency, paymentMethodModelStream: CurrentValuePublisher<PaymentMethodModel>) {
        self.paymentMethodModelStream = paymentMethodModelStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TopupListener) -> TopupRouting {
        let paymentMethodModelStream = CurrentValuePublisher(PaymentMethodModel(id: "", name: "", digits: "", color: "", isPrimary: false))
        let component = TopupComponent(dependency: dependency, paymentMethodModelStream: paymentMethodModelStream)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let enterAmountBuilder = EnterAmountBuilder(dependency: component)
        let cardOnFileBuilder = CardOnFileBuilder(dependency: component)

        return TopupRouter(interactor: interactor,
                           viewController: component.topupBaseViewController,
                           addPaymentMethodBuildable: addPaymentMethodBuilder,
                           enterAmountBuildable: enterAmountBuilder,
                           cardOnFileBuildable: cardOnFileBuilder)
    }
}

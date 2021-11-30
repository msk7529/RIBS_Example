//
//  EnterAmountBuilder.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/11/15.
//

import CombineUtil
import FinanceEntity
import ModernRIBs

protocol EnterAmountDependency: Dependency {
    var selectedPaymentMethodModel: ReadOnlyCurrentValuePublisher<PaymentMethodModel> { get }
    var superPayRepository: SuperPayRepository { get }
}

final class EnterAmountComponent: Component<EnterAmountDependency>, EnterAmountInteractorDependency {
    var selectedPaymentMethodModel: ReadOnlyCurrentValuePublisher<PaymentMethodModel> {
        return dependency.selectedPaymentMethodModel
    }
    
    var superPayRepository: SuperPayRepository {
        return dependency.superPayRepository
    }
}

// MARK: - Builder

protocol EnterAmountBuildable: Buildable {
    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting
}

final class EnterAmountBuilder: Builder<EnterAmountDependency>, EnterAmountBuildable {

    override init(dependency: EnterAmountDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
        let component = EnterAmountComponent(dependency: dependency)
        let viewController = EnterAmountViewController()
        let interactor = EnterAmountInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return EnterAmountRouter(interactor: interactor, viewController: viewController)
    }
}

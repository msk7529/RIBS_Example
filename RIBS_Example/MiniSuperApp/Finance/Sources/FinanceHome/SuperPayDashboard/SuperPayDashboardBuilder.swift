//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//

import ModernRIBs
import Foundation
import CombineUtil

protocol SuperPayDashboardDependency: Dependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>, SuperPayDashboardInteractorDependency {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.

    var balance: ReadOnlyCurrentValuePublisher<Double> { return dependency.balance }
    var balanceFormatter: NumberFormatter { return Formatter.balacneFormatter }
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}

final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable {

    override init(dependency: SuperPayDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
        let component = SuperPayDashboardComponent(dependency: dependency)
        let viewController = SuperPayDashboardViewController()
        let interactor = SuperPayDashboardInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
    }
}

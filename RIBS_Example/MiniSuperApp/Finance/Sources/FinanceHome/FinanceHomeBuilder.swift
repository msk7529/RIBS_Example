import CombineUtil
import AddPaymentMethod
import FinanceRepository
import Foundation
import ModernRIBs
import Topup
import Network
import NetworkImp

public protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {    
    let cardOnFileRepository: CardOnFileRepository
    let superPayRepository: SuperPayRepository
    
    var balance: ReadOnlyCurrentValuePublisher<Double> {
        return superPayRepository.balance
    }
    var topupBaseViewController: ViewControllable
        
    init(dependency: FinanceHomeDependency,
         cardOnFileRepository: CardOnFileRepository,
         superPayRepository: SuperPayRepository,
         topupBaseViewController: ViewControllable) {
        self.cardOnFileRepository = cardOnFileRepository
        self.superPayRepository = superPayRepository
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    public override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
        let viewController = FinanceHomeViewController()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [SuperAppURLProtocol.self]
        
        setupURLProtocol()
        
        let network = NetworkImp(session: URLSession(configuration: config))
        
        let component = FinanceHomeComponent(dependency: dependency,
                                             cardOnFileRepository: CardOnFileRepositoryImp(),
                                             superPayRepository: SuperPayRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL),
                                             topupBaseViewController: viewController)
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let topupBuilder = TopupBuilder(dependency: component)
        
        return FinanceHomeRouter(interactor: interactor,
                                 viewController: viewController,
                                 superPayDashboardBuildable: superPayDashboardBuilder,
                                 cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
                                 addPaymentMethodBuildable: addPaymentMethodBuilder,
                                 topupBuildable: topupBuilder)
    }
}

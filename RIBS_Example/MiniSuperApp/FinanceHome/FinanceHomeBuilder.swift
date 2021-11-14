import ModernRIBs

protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {    
    let cardOnFileRepository: CardOnFileRepository
    
    var balance: ReadOnlyCurrentValuePublisher<Double> {
        return balancePublisher
    }
    var topupBaseViewController: ViewControllable
    
    private let balancePublisher: CurrentValuePublisher<Double>
    
    init(dependency: FinanceHomeDependency, balance: CurrentValuePublisher<Double>, cardOnFileRepository: CardOnFileRepository, topupBaseViewController: ViewControllable) {
        self.balancePublisher = balance
        self.cardOnFileRepository = cardOnFileRepository
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
        let viewController = FinanceHomeViewController()
        
        let balancePublisher = CurrentValuePublisher<Double>(10000)
        
        let component = FinanceHomeComponent(dependency: dependency, balance: balancePublisher, cardOnFileRepository: CardOnFileRepositoryImp(), topupBaseViewController: viewController)
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

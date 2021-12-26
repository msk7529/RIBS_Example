import ModernRIBs
import FinanceRepository
import CombineUtil
import Topup
import TransportHome

public protocol TransportHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    
    var topupBuildable: TopupBuildable { get }
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
    
    var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
}

// MARK: - Builder
public final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
    
    public override init(dependency: TransportHomeDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: TransportHomeListener) -> ViewableRouting {
        let component = TransportHomeComponent(dependency: dependency)
        let viewController = TransportHomeViewController()
        let interactor = TransportHomeInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        
        return TransportHomeRouter(
            interactor: interactor,
            viewController: viewController,
            topupBuildable: component.topupBuildable
        )
    }
}

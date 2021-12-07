import ModernRIBs

public protocol TransportHomeDependency: Dependency {
}

final class TransportHomeComponent: Component<TransportHomeDependency> {
    
}

// MARK: - Builder

public protocol TransportHomeBuildable: Buildable {
    func build(withListener listener: TransportHomeListener) -> ViewableRouting
}

public final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
    
    public override init(dependency: TransportHomeDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: TransportHomeListener) -> ViewableRouting {
        _ = TransportHomeComponent(dependency: dependency)
        
        let viewController = TransportHomeViewController()
        
        let interactor = TransportHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        return TransportHomeRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}

//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//

import ModernRIBs
import Combine
import Foundation

protocol SuperPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
    var listener: SuperPayDashboardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func updateBalence(_ balence: String)
}

protocol SuperPayDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func superPayDashboardDidTapTopup()
}

protocol SuperPayDashboardInteractorDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    var balanceFormatter: NumberFormatter { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {

    private let dependency: SuperPayDashboardInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    weak var router: SuperPayDashboardRouting?
    weak var listener: SuperPayDashboardListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: SuperPayDashboardPresentable, dependency: SuperPayDashboardInteractorDependency) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        // TODO: Implement business logic here.
        super.didBecomeActive()
        
        dependency.balance
            .receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] balence in
            self?.dependency.balanceFormatter.string(from: NSNumber(value: balence)).map {
                self?.presenter.updateBalence($0)
            }
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapTopupButton() {
        listener?.superPayDashboardDidTapTopup()
    }
}

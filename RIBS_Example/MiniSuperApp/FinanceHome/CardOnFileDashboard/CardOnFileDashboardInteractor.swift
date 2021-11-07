//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/10/27.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    // TODO: Declare methods the interactor can invoke the presenter to present data.

    var listener: CardOnFileDashboardPresentableListener? { get set }
    
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileDashboardInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    private let dependency: CardOnFileDashboardInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: CardOnFileDashboardPresentable, dependency: CardOnFileDashboardInteractorDependency) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        
        presenter.listener = self
    }

    override func didBecomeActive() {
        // TODO: Implement business logic here.
        super.didBecomeActive()
        
        dependency.cardsOnFileRepository.cardOnFile.sink { methodModel in
            let viewModels = methodModel.prefix(5).map { PaymentMethodViewModel($0) }
            self.presenter.update(with: viewModels)
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        // TODO: Pause any business logic.
        super.willResignActive()
        
        // 이렇게 해주면 위의 sink 클로저에 [weak self]를 하지 않아도 됨.
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didTapAddPaymentmethod() {
        // 여기보다 financeHome에서 띄우는게 구조상 맞아보임
        listener?.cardOnFileDashboardDidTapAddPaymentMethod()
    }
}

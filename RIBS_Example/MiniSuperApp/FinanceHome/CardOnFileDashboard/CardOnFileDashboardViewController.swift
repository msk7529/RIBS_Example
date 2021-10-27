//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/10/27.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {

    private let headerStackView: UIStackView = {
        let stackView: UIStackView = .init(frame: .zero)
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "카드 및 계좌"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.setTitle("전체보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapSeeAllButton), for: .touchUpInside)
        return button
    }()
    
    private let cardOnFileStacakView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var addMethodButton: AddPaymentMethodButton = {
        let button: AddPaymentMethodButton = .init()
        button.roundCorners()
        button.backgroundColor = .systemGray4
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var listener: CardOnFileDashboardPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(headerStackView)
        view.addSubview(cardOnFileStacakView)
        
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(seeAllButton)
                
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardOnFileStacakView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            cardOnFileStacakView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardOnFileStacakView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardOnFileStacakView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addMethodButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func update(with viewModels: [PaymentMethodViewModel]) {
        cardOnFileStacakView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let views = viewModels.map { PaymentMethodView(viewModel: $0) }
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
            $0.roundCorners()
            cardOnFileStacakView.addArrangedSubview($0)
        }
        
        cardOnFileStacakView.addArrangedSubview(addMethodButton)
    }
    
    @objc
    private func didTapSeeAllButton() {
        
    }
    
    @objc
    private func didTapAddButton() {
        
    }
}

//
//  PaymentMethodView.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/10/27.
//

import UIKit

final class PaymentMethodView: UIView {
    private let nameLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.text = "우리은행"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.text = "**** 9999"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: PaymentMethodViewModel) {
        super.init(frame: .zero)
        
        setupViews()
        
        nameLabel.text = viewModel.name
        subtitleLabel.text = viewModel.digits
        backgroundColor = viewModel.color
    }
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .systemIndigo
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            subtitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

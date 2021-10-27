//
//  AddPaymentMethodButton.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/10/27.
//

import UIKit

final class AddPaymentMethodButton: UIControl {
    private let plusIcon: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(plusIcon)
        
        NSLayoutConstraint.activate([
            plusIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plusIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

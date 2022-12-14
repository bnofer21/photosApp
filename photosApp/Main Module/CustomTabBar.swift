//
//  CustomTabBar.swift
//  photosApp
//
//  Created by Юрий on 14.12.2022.
//

import UIKit

class CustomTabBar: UIView {
    
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -8.0)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 10.0
        containerView.layer.cornerRadius = layer.cornerRadius
        containerView.layer.masksToBounds = true
        addView(containerView)
        setConstraints()
    }
}

extension CustomTabBar {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
}

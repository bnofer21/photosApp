//
//  LoginButton.swift
//  photosApp
//
//  Created by Юрий on 05.12.2022.
//

import UIKit

class LoginButton: LoaderButton {
    
    override var isEnabled: Bool {
        willSet {
            backgroundColor = newValue ? .blue : .gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle(Resources.AuthForm.signIn.rawValue, for: .normal)
        backgroundColor = .gray
        isEnabled = false
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

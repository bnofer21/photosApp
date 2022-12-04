//
//  AuthViewModel.swift
//  photosApp
//
//  Created by Юрий on 05.12.2022.
//

import Foundation

struct AuthViewModel {
    
    var form = Resources.AuthForm.signIn
    
    var username: String?
    var email: String?
    var password: String?
    
    var isValid: Bool {
        switch form {
        case .signIn:
            return email?.isEmpty == false && password?.isEmpty == false
        case .signUp:
            return username?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        default:
            return email?.isEmpty == false
        }
    }
    
}

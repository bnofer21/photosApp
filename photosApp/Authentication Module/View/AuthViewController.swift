//
//  AuthViewController.swift
//  photosApp
//
//  Created by Юрий on 05.12.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var viewModel = AuthViewModel()
    
    var authLabel: UILabel = {
        let label = UILabel()
        label.text = Resources.AuthForm.signIn.rawValue
        label.font = label.font.withSize(20)
        return label
    }()
    var fields = [DataTextField]()
    var fieldsStackView = UIStackView()
    var loginButton = LoginButton()
    var changeForm: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(13)
        return button
    }()
    
// MARK: Configure UI

    override func viewDidLoad() {
        setupView()
        setConstraints()
        setTargets()
        configureStackView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addView(authLabel)
        view.addView(fieldsStackView)
        view.addView(loginButton)
        view.addView(changeForm)
        createTextfields()
    }
    
    private func setTargets() {
        changeForm.addTarget(self, action: #selector(didTapChangeForm), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin(sender:)), for: .touchUpInside)
        
    }
    
    private func configureStackView() {
        fieldsStackView.spacing = 10
        fieldsStackView.axis = .vertical
        fieldsStackView.distribution = .fillEqually
    }
    
    private func createTextfields() {
        
        for i in 0..<Resources.Fields.allCases.count {
            let tf = DataTextField()
            if i == 0 {
                tf.isHidden = true
            }
            tf.field = Resources.Fields.allCases[i]
            tf.placeholder = Resources.Fields.allCases[i].rawValue
            tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            fields.append(tf)
            fieldsStackView.addArrangedSubview(tf)
            
        }
    }
    
// MARK: objc methods
    
    @objc func didTapLogout() {
        Authentication.shared.logout()
    }
    
    @objc func didTapLogin(sender: LoginButton) {
        print("tap login")
        sender.showLoading()
        switch viewModel.form {
        case .signIn:
            guard let email = viewModel.email, let password = viewModel.password else { return }
            Authentication.shared.logIn(email: email, password: password) { error in
                if let error = error {
                    self.presentError(message: error)
                } else {
                    self.dismiss(animated: true)
                }
                sender.hideLoading()
            }
        case .signUp:
            guard let username = viewModel.username, let email = viewModel.email, let password = viewModel.password else { return }
            Authentication.shared.signUp(username: username, email: email, password: password) { error in
                if let error = error {
                    self.presentError(message: error)
                } else {
                    self.dismiss(animated: true)
                }
                sender.hideLoading()
            }
            self.dismiss(animated: true)
        case .reset:
            guard let email = viewModel.email else { return }
            Authentication.shared.resetPassword(email: email) { error in
                if let error = error {
                    self.presentError(message: error)
                } else {
                    self.presentSuccess(message: "The password reset sent to your e-mail address")
                }
                sender.hideLoading()
            }
        }
    }
    
    @objc func textFieldDidChange(_ textfield: DataTextField) {
        
        let text = textfield.text
        switch textfield.field {
        case .email:
            viewModel.email = text
        case .name:
            viewModel.username = text
        default:
            viewModel.password = text
        }
        loginButton.isEnabled = viewModel.isValid
    }
    
    @objc func didTapChangeForm() {
        switch viewModel.form {
        case .signIn:
            viewModel.form = .signUp
            fields[0].isHidden = false
            authLabel.text = Resources.AuthForm.signUp.rawValue
            loginButton.setTitle(Resources.AuthForm.signUp.rawValue, for: .normal)
            changeForm.setTitle(Resources.AuthForm.signIn.rawValue, for: .normal)
        case .signUp:
            viewModel.form = .signIn
            fields[0].isHidden = true
            fields[0].text = ""
            authLabel.text = Resources.AuthForm.signIn.rawValue
            loginButton.setTitle(Resources.AuthForm.signIn.rawValue, for: .normal)
            changeForm.setTitle(Resources.AuthForm.signUp.rawValue, for: .normal)
        default:
            viewModel.form = .signIn
            authLabel.text = Resources.AuthForm.signIn.rawValue
            loginButton.setTitle(Resources.AuthForm.signIn.rawValue, for: .normal)
            changeForm.setTitle(Resources.AuthForm.signUp.rawValue, for: .normal)
            for tf in fields {
                tf.isHidden = false
            }
        }
        loginButton.isEnabled = viewModel.isValid
    }
    
}

// MARK: Hide kb when tapped outside
extension AuthViewController: UITextFieldDelegate {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


// MARK: Constraints
extension AuthViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            authLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            authLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            fields[0].heightAnchor.constraint(equalToConstant: 50),
            fields[1].heightAnchor.constraint(equalToConstant: 50),
            
            fieldsStackView.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: 20),
            fieldsStackView.widthAnchor.constraint(equalToConstant: 350),
            fieldsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalTo: fieldsStackView.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            changeForm.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            changeForm.widthAnchor.constraint(equalToConstant: 70),
            changeForm.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

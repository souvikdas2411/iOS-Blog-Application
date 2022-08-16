//
//  SignUpViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import UIKit

class SignUpViewController: UITabBarController {

    private let headerView = SignUpHeaderView()
    
    private let fullName: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Full Name"
        field.backgroundColor = .separator
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Email Address"
        field.backgroundColor = .separator
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Password"
        field.backgroundColor = .separator
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    private let repeatPasswordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Re-enter Password"
        field.backgroundColor = .separator
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign Up"
        view.backgroundColor = .systemBackground
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        view.addSubview(headerView)
        view.addSubview(fullName)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(repeatPasswordField)
        view.addSubview(signUpButton)
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
        fullName.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 20, width: view.width - 40, height: 50)
        emailField.frame = CGRect(x: 20, y: fullName.bottom + 10, width: view.width - 40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width - 40, height: 50)
        repeatPasswordField.frame = CGRect(x: 20, y: passwordField.bottom + 10, width: view.width - 40, height: 50)
        signUpButton.frame = CGRect(x: view.width/2 - ((view.width/3)/2), y: repeatPasswordField.bottom + 20, width: view.width/3, height: 50)
        
    }
    
    @objc func didTapSignUp() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let checkPass = repeatPasswordField.text, !checkPass.isEmpty,
              let name = fullName.text, !name.isEmpty, password == checkPass  else {
                  let dialogMessage = UIAlertController(title: "Alert", message: "Please fill the details correctly!", preferredStyle: .alert)
                  let ok = UIAlertAction(title: "Try again", style: .default, handler: { (action) -> Void in
                      self.passwordField.text = ""
                      self.repeatPasswordField.text = ""
                  })
                  dialogMessage.addAction(ok)
                  self.present(dialogMessage, animated: true, completion: nil)
                  return
              }
        
        AuthManager.shared.signUp(email: email, password: password){ [weak self] success in
            if success {
                let newUser = User(name: name, email: email, profilePictureRef: nil)
                DatabaseManager.shared.insertUser(user: newUser){ inserted in
                    guard inserted else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(name, forKey: "name")
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            } else {
                let dialogMessage = UIAlertController(title: "Alert", message: "Something went wrong!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Try again", style: .default, handler: { (action) -> Void in
                    self?.passwordField.text = ""
                })
                dialogMessage.addAction(ok)
                self?.present(dialogMessage, animated: true, completion: nil)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

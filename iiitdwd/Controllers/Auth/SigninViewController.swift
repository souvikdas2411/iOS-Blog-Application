//
//  SiginViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import UIKit

class SigninViewController: UITabBarController {

    private let headerView = SignInHeaderView()
    
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
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .separator
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        indicator.style = .large
        indicator.backgroundColor = .separator
        indicator.layer.cornerRadius = 30
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        view.backgroundColor = .systemBackground
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+1){
//            if !IAPManager.shared.isPremium() {
//                let vc = PayWallViewController()
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)
        view.addSubview(activityIndicator)
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
        emailField.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 20, width: view.width - 40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width - 40, height: 50)
        signInButton.frame = CGRect(x: view.width/2 - ((view.width/3)/2), y: passwordField.bottom + 20, width: view.width/3, height: 50)
        createAccountButton.frame = CGRect(x: view.width/2 - ((view.width/5)/2), y: signInButton.bottom + 10, width: view.width/5, height: 50)
        activityIndicator.frame = CGRect(x: view.width/2 - 30, y: view.height/2 - 30, width: 60, height: 60)
        
    }
    
    @objc func didTapSignIn() {
        
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
                  let dialogMessage = UIAlertController(title: "Alert", message: "Please fill the details!", preferredStyle: .alert)
                  let ok = UIAlertAction(title: "Try again", style: .default, handler: { (action) -> Void in
                      self.passwordField.text = ""
                  })
                  dialogMessage.addAction(ok)
                  self.present(dialogMessage, animated: true, completion: nil)
                  return
              }
        
        view.isUserInteractionEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        AuthManager.shared.signIn(email: email, password: password){ [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.view.isUserInteractionEnabled = true
                    self!.activityIndicator.isHidden = true
                    self!.activityIndicator.stopAnimating()
                    UserDefaults.standard.set(email, forKey: "email")
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
            }
            else {
                self?.view.isUserInteractionEnabled = true
                self!.activityIndicator.isHidden = true
                self!.activityIndicator.stopAnimating()
                let dialogMessage = UIAlertController(title: "Alert", message: "Something went wrong!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Try again", style: .default, handler: { (action) -> Void in
                    self?.passwordField.text = ""
                })
                dialogMessage.addAction(ok)
                self?.present(dialogMessage, animated: true, completion: nil)
            }
            
        }
        
    }
    
    @objc func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.title = "Sign Up"
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

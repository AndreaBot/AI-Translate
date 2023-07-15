//
//  LoginViewController.swift
//  AI Translate
//
//  Created by Andrea Bottino on 28/06/2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let showPasswordButton = UIButton()
    
    let blueColor = CGColor(red: 0, green: 0.4, blue: 1, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        setupUI()
    }
    
    func setupUI() {

        showPasswordButton.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        showPasswordButton.tintColor = .black
        showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        
        let customRightView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 40))
        customRightView.addSubview(showPasswordButton)
    
        emailLabel.textColor = .black
        passwordLabel.textColor = .black
        
        emailTextField.textColor = .black
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = .white
        emailTextField.layer.cornerRadius = 7
        emailTextField.layer.borderColor = blueColor
        emailTextField.layer.borderWidth = 2
        
        passwordTextField.textColor = .black
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .white
        passwordTextField.layer.cornerRadius = 7
        passwordTextField.layer.borderColor = blueColor
        passwordTextField.layer.borderWidth = 2
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = customRightView
        passwordTextField.rightViewMode = .always

        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = blueColor
        loginButton.layer.borderWidth = 2
    }
    
    
    @IBAction func loginUser(_ sender: UIButton) {
        
        if let userEmail = emailTextField.text, let userPassword = passwordTextField.text {
            Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
                if let e = error {
                    self.showAlert(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.Segues.loginToTranslator, sender: self)
                }
            }
        }
    }
    
    @objc func showPassword() {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel))
        present(alert, animated: true)
    }
}

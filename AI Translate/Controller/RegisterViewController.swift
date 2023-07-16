//
//  RegisterViewController.swift
//  AI Translate
//
//  Created by Andrea Bottino on 28/06/2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var showPasswordsButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    let blueColor = CGColor(red: 0, green: 0.4, blue: 1, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        //emailTextField.delegate = self
       
        setupUI()
    }
    
    func setupUI() {
        
        emailLabel.textColor = .black
        passwordLabel.textColor = .black
        repeatPasswordLabel.textColor = .black
        
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
        
        repeatPasswordTextField.textColor = .black
        repeatPasswordTextField.borderStyle = .roundedRect
        repeatPasswordTextField.backgroundColor = .white
        repeatPasswordTextField.layer.cornerRadius = 7
        repeatPasswordTextField.layer.borderColor = blueColor
        repeatPasswordTextField.layer.borderWidth = 2
        repeatPasswordTextField.isSecureTextEntry = true
        
        showPasswordsButton.tintColor = .black

        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 10
        
        
    }
    
    @IBAction func registerUser(_ sender: UIButton) {
        
        if passwordTextField.text == repeatPasswordTextField.text && passwordTextField.text != nil && repeatPasswordTextField.text != nil {
            if let userEmail = emailTextField.text, let userPassword = passwordTextField.text {
                Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
                    if let e = error {
                        self.showAlert(e.localizedDescription)
                    } else {
                        self.performSegue(withIdentifier: K.Segues.registerToTranslator, sender: self)
                    }
                }
            }
        } else {
            showAlert("The password hasn't been set or the passwords don't match")
        }
    }
    
    
    @IBAction func showPasswordsPressed(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry == true && repeatPasswordTextField.isSecureTextEntry == true {
                passwordTextField.isSecureTextEntry = false
            repeatPasswordTextField.isSecureTextEntry = false
                sender.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                passwordTextField.isSecureTextEntry = true
                repeatPasswordTextField.isSecureTextEntry = true
                sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)

            }
    }
    
        func showAlert(_ message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .cancel))
            present(alert, animated: true)
        }
}

//    //MARK: - UITextField Delegate
//
//    extension RegisterViewController: UITextFieldDelegate {
//
//    }


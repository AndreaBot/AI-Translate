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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPasswordsButton.tintColor = .white
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
        //emailTextField.delegate = self
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


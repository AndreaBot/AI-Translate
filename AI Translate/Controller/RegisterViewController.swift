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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


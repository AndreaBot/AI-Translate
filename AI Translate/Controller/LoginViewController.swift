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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showPasswordButton.setImage(UIImage(systemName: "Eye.slash"), for: .normal)
        showPasswordButton.tintColor = .white
        passwordTextField.isSecureTextEntry = true
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
    
    @IBAction func showPasswordPressed(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry == true {
                passwordTextField.isSecureTextEntry = false
                sender.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                passwordTextField.isSecureTextEntry = true
                sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)

            }
    }
    
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel))
        present(alert, animated: true)
    }
}

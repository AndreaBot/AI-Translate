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
    
    @IBOutlet weak var emailTextField: CustomUITextField!
    @IBOutlet weak var passwordTextField: CustomUITextField!
    @IBOutlet weak var repeatPasswordTextField: CustomUITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    let showPasswordButton = CustomUIButton()
    let showRepeatPasswordButton = CustomUIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        //emailTextField.delegate = self
        setupUI()
    }
    
    func setupUI() {
        
        showPasswordButton.addTarget(self, action: #selector(showPasswords), for: .touchUpInside)
        showRepeatPasswordButton.addTarget(self, action: #selector(showPasswords), for: .touchUpInside)
        
        let firstCustomRightView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 40))
        firstCustomRightView.addSubview(showPasswordButton)

        let secondCustomRightView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 40))
        secondCustomRightView.addSubview(showRepeatPasswordButton)

        passwordTextField.rightView = firstCustomRightView
        passwordTextField.rightViewMode = .always
        
        repeatPasswordTextField.rightView = secondCustomRightView
        repeatPasswordTextField.rightViewMode = .always

        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 10
    }
    
    @objc func showPasswords() {
        
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
            repeatPasswordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
            showRepeatPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            repeatPasswordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            showRepeatPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
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


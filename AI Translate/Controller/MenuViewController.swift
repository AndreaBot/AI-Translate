//
//  MenuViewController.swift
//  AI Translate
//
//  Created by Andrea Bottino on 11/07/2023.
//

import UIKit
import FirebaseAuth

protocol MenuViewControllerDelegate: AnyObject {
    func goToSavedTranslations()
    func logoutConfirmation()
    func deleteConfirmation()
    
}
class MenuViewController: UIViewController {

    @IBOutlet weak var savedTranslationsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedTranslationsButton.layer.cornerRadius = 10
        logoutButton.layer.cornerRadius = 10
        deleteAccountButton.layer.cornerRadius = 10
        
        savedTranslationsButton.tintColor = .systemBlue
        logoutButton.tintColor = .systemBlue
        deleteAccountButton.tintColor = .systemBlue

        if Auth.auth().currentUser == nil {
            logoutButton.isEnabled = false
            logoutButton.alpha = 0.3
            deleteAccountButton.isEnabled = false
            deleteAccountButton.alpha = 0.3
        }
    }

    @IBAction func savedTranslationsPressed(_ sender: UIButton) {
        
        delegate?.goToSavedTranslations()
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        
        delegate?.logoutConfirmation()
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        
        delegate?.deleteConfirmation()
    }
    
}

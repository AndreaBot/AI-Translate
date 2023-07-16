//
//  HomeViewController.swift
//  AI Translate
//
//  Created by Andrea Bottino on 16/07/2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            
            if Auth.auth().currentUser != nil {
                performSegue(withIdentifier: K.Segues.goToMainApp, sender: self)
            } else {
                performSegue(withIdentifier: K.Segues.showLoginOptions, sender: self)
            }
        }
    }
}

//
//  HomeViewController.swift
//  AI Translate
//
//  Created by Andrea Bottino on 28/06/2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    
    var blueColour = CGColor(red: 0, green: 0.4, blue: 1, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().tintColor = .black
        setupUI()
    }
    
    func setupUI() {
        
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 10
        
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = blueColour
        loginButton.layer.borderWidth = 2
    }

    @IBAction func continueAsGuestPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.homeToTranslator, sender: self)
    }
}

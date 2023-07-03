//
//  HomeViewController.swift
//  AI Translate
//
//  Created by Andrea Bottino on 28/06/2023.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func continueAsGuestPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.homeToTranslator, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.homeToTranslator {
            let destinationVC = segue.destination as? TranslatorViewController
            destinationVC?.cameFromLogin = false
        }
    }
    
}

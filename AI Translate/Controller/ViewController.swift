//
//  ViewController.swift
//  Translate
//
//  Created by Andrea Bottino on 15/05/2023.
//

import UIKit

class ViewController: UIViewController, TranslationManagerDelegate {
    func showTranslation(_ translation: String) {
        DispatchQueue.main.async {
            self.translationLabel.text = translation
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    
    @IBOutlet weak var translationLabel: UILabel!
    
    var tranlationManager = TranslationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tranlationManager.delegate = self

    }
    
    
    @IBAction func translatePressed(_ sender: UIButton) {
        tranlationManager.getTranslation()
    }
}

//
//  DetailedViewController.swift
//  AI Translate
//
//  Created by Andrea Bottino on 07/07/2023.
//

import UIKit

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var sourceLanguageFlag: UILabel!
    @IBOutlet weak var originalText: UITextView!
    @IBOutlet weak var translationLanguageFlag: UILabel!
    @IBOutlet weak var translationText: UITextView!

    var textForSourceFlag: String?
    var textForOriginalText: String?
    var textForTranslationFlag: String?
    var textForTranslationText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalText.layer.cornerRadius = 10
        originalText.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        translationText.layer.cornerRadius = 10
        translationText.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        sourceLanguageFlag.text = textForSourceFlag
        originalText.text = textForOriginalText
        translationLanguageFlag.text = textForTranslationFlag
        translationText.text = textForTranslationText
        
    }
}
    





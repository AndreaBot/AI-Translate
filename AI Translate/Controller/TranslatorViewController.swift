//
//  ViewController.swift
//  Translate
//
//  Created by Andrea Bottino on 15/05/2023.
//

import UIKit

class TranslatorViewController: UIViewController {
    
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var sourcePicker: UIPickerView!
    @IBOutlet weak var targetPicker: UIPickerView!
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var translatedText: UITextView!
    
    var translationManager = TranslationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        translationManager.delegate = self
        targetPicker.dataSource = self
        targetPicker.delegate = self
        textToTranslate.delegate = self

        textToTranslate.layer.cornerRadius = 15
        translatedText.layer.cornerRadius = 15
        UITextView.appearance().backgroundColor = UIColor(white: 1, alpha: 1)
        UITextView.appearance().textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        translateButton.layer.cornerRadius = 30
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexible, doneButton], animated: false)
        textToTranslate.inputAccessoryView = toolbar
    }
    
}


//MARK: - TranslationManagerDelegate

extension TranslatorViewController: TranslationManagerDelegate {
    
    func showTranslation(_ translation: String) {
        DispatchQueue.main.async {
            self.translatedText.text = translation
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    @IBAction func translatePressed(_ sender: UIButton) {
        if textToTranslate.text != "" {
            let text = textToTranslate.text
            
            translationManager.parameters["text"] = text
        }
        translationManager.getTranslation()  
    }
}

//MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension TranslatorViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sourcePicker {
            return translationManager.sourceOptions.count
        } else {
            return translationManager.targetOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sourcePicker {
            return translationManager.sourceOptions[row]
        } else {
            return translationManager.targetOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sourcePicker {
            let chosenSourceLang = translationManager.sourceOptions[row]
            translationManager.parameters["source"] = translationManager.convertSourceLanguage(chosenSourceLang)
        } else {
            let chosenTargetLang = translationManager.targetOptions[row]
            translationManager.parameters["target"] = translationManager.convertTargetLanguage(chosenTargetLang)
        }
    }
}

//MARK: - UITextViewDelegate

extension TranslatorViewController: UITextViewDelegate {
    
    @objc func doneButtonTapped() {
        textToTranslate.resignFirstResponder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        doneButtonTapped()
        translationManager.parameters["text"] = UITextView.text
    }
}




//
//  ViewController.swift
//  Translate
//
//  Created by Andrea Bottino on 15/05/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var sourcePicker: UIPickerView!
    @IBOutlet weak var targetPicker: UIPickerView!
    @IBOutlet weak var textToTranslate: UITextField!
    
    var translationManager = TranslationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translationManager.delegate = self
        targetPicker.dataSource = self
        targetPicker.delegate = self
        textToTranslate.delegate = self
    }
}

//MARK: - TranslationManagerDelegate

extension ViewController: TranslationManagerDelegate {
    
    func showTranslation(_ translation: String) {
        DispatchQueue.main.async {
            self.translationLabel.text = translation
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    @IBAction func translatePressed(_ sender: UIButton) {
        translationManager.getTranslation()  
    }
}

//MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
            translationManager.parameters["source"] = translationManager.sourceOptions[row]
        } else {
            translationManager.parameters["target"] = translationManager.targetOptions[row]
        }
    }
}

//MARK: - UITexFiedlDelegate
    
extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textToTranslate.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textToTranslate.text != "" {
            return true
        } else {
            textField.placeholder = "What do you need to translate?"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        translationManager.parameters["text"] = textField.text
    }
}



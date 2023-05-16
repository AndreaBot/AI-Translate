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
    
    var tranlationManager = TranslationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tranlationManager.delegate = self
        
        targetPicker.dataSource = self
        targetPicker.delegate = self
        
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
        tranlationManager.getTranslation()
    }
}

//MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sourcePicker {
            return tranlationManager.sourceOptions.count
        } else {
            return tranlationManager.targetOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sourcePicker {
            return tranlationManager.sourceOptions[row]
        } else {
            return tranlationManager.targetOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sourcePicker {
            tranlationManager.parameters["source"] = tranlationManager.sourceOptions[row]
        } else {
            tranlationManager.parameters["target"] = tranlationManager.targetOptions[row]
        }
    }
}


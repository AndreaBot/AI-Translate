//
//  ViewController.swift
//  Translate
//
//  Created by Andrea Bottino on 15/05/2023.
//

import UIKit
import AVFoundation

class TranslatorViewController: UIViewController {
    
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var sourcePicker: UIPickerView!
    @IBOutlet weak var targetPicker: UIPickerView!
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var hearTranslationButton: UIButton!
    
    var translationManager = TranslationManager()
    var textReaderManager = TextReaderManager()
    var player: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        translationManager.delegate = self
        targetPicker.dataSource = self
        targetPicker.delegate = self
        textToTranslate.delegate = self
        textReaderManager.delegate = self

        textToTranslate.layer.cornerRadius = 10
        translatedText.layer.cornerRadius = 10
        UITextView.appearance().backgroundColor = UIColor(white: 1, alpha: 1)
        UITextView.appearance().textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        translateButton.layer.cornerRadius = 30
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexible, doneButton], animated: false)
        textToTranslate.inputAccessoryView = toolbar
        
        hearTranslationButton.tintColor = .white
    }
    
}


//MARK: - TranslationManagerDelegate

extension TranslatorViewController: TranslationManagerDelegate {
    
    func showTranslation(_ translation: String) {
        DispatchQueue.main.async {
            self.translatedText.text = translation
            
                var parameters = self.textReaderManager.parameters
                if var input = parameters["input"] as? [String: String] {
                input["text"] = translation
                parameters["input"] = input
                self.textReaderManager.parameters = parameters
                
            } else {
                print("Unable to modify text value in parameters")
            }
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    @IBAction func translatePressed(_ sender: UIButton) {
        if textToTranslate.text == "" {
            noTextAlert()
        } else {
            translationManager.parameters["text"] = textToTranslate.text
            translationManager.getTranslation()
        }
    }

    func noTextAlert() {
        let alert = UIAlertController(title: "Please type something to translate first.", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
            
               var parameters = self.textReaderManager.parameters
               if var voice = parameters["voice"] as? [String: String] {
                voice["languageCode"] = textReaderManager.convertVoiceLanguageCode(chosenTargetLang)
                voice["name"] = textReaderManager.pickVoice(chosenTargetLang)
                voice["ssmlGender"] = textReaderManager.pickGender(chosenTargetLang)
                parameters["voice"] = voice
                self.textReaderManager.parameters = parameters
 
            } else {
                print("Unable to modify text value in parameters")
            }
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

//MARK: - TextReaderManagerDelegate

extension TranslatorViewController: TextReaderManagerDelegate {
    
    func playAudio(_ base64String: String) {

        guard let audioData = Data(base64Encoded: base64String) else {
            return
        }

        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("audio.mp3")
        print(fileURL)
        
        do {
            try audioData.write(to: fileURL)
            player = try AVAudioPlayer(contentsOf: fileURL)
            player?.play()
            
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }

    func didFail(_ error: Error) {
        print(error)
    }

    @IBAction func hearTranslation(_ sender: UIButton) {
        let parameters = self.textReaderManager.parameters
        let input = parameters["input"] as? [String: String]
        if input!["text"] == "" {
            noTranslationAlert()
        } else {
            textReaderManager.generateVoice()
        }
    }
  
    func noTranslationAlert() {
        let alert = UIAlertController(title: "Nothing has been translated yet.", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

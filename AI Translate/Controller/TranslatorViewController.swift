//
//  ViewController.swift
//  Translate
//
//  Created by Andrea Bottino on 15/05/2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import AVFoundation

class TranslatorViewController: UIViewController {
    
    @IBOutlet weak var sourcePicker: UIPickerView!
    @IBOutlet weak var targetPicker: UIPickerView!
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var hearTranslationButton: UIButton!
    @IBOutlet weak var saveTranslationButton: UIButton!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var myTranslationButton : UIBarButtonItem!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser!
    
    var translationManager = TranslationManager()
    var textReaderManager = TextReaderManager()
    var player: AVAudioPlayer?
    
    var chosenSourceLang: String!
    var chosenTargetLang: String!
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    func showTimedAlert() {
        let alert = UIAlertController(title: "Success", message: "Translation saved.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if Auth.auth().currentUser == nil {
            navigationItem.hidesBackButton = false
            logoutButton.isHidden = true
        } else {
            navigationItem.hidesBackButton = true
            logoutButton.isHidden = false
        }
        
        saveTranslationButton.isEnabled = false
        hearTranslationButton.isEnabled = false
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
        saveTranslationButton.tintColor = .white
    }
    
    @IBAction func logoutUser(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func saveTranslationPressed(_ sender: UIButton) {
        if Auth.auth().currentUser == nil {
            showAlert(with: "You need to be logged in as an user to save translations.")
        } else {
            if let sourceLang = chosenSourceLang, let originalText = textToTranslate.text, let targetLang = chosenTargetLang, let finalText = translatedText.text {
                db.collection(Auth.auth().currentUser!.uid ).addDocument(data: [
                    K.Firestore.sourceLanguage: sourceLang,
                    K.Firestore.originalText: originalText,
                    K.Firestore.targetLanguage: targetLang,
                    K.Firestore.translation: finalText,
                    K.Firestore.dateField: Date().timeIntervalSince1970
                ])
                 { (error) in
                    if let e = error {
                        print("there was an error adding data to firestore, \(e)")
                    } else {
                        sender.isEnabled = false
                        sender.setImage(UIImage(systemName: "heart.fill"), for: .disabled)
                        self.showTimedAlert()
                    }
                }
            }
        }
    }
    
    @IBAction func myTranslationsPressed(_ sender: UIBarButtonItem) {
        
        if Auth.auth().currentUser == nil {
            showAlert(with: "You need to be logged in as an user to access saved translations.")
        } else {
            performSegue(withIdentifier: K.Segues.translatorToSaved, sender: self)
        }
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
            showAlert(with: "Please type something to translate first.")
        } else {
            translationManager.parameters["text"] = textToTranslate.text
            translationManager.getTranslation()
            saveTranslationButton.isEnabled = true
            hearTranslationButton.isEnabled = true
        }
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
            chosenSourceLang = translationManager.sourceOptions[row]
            translationManager.parameters["source"] = translationManager.convertSourceLanguage(chosenSourceLang!)
        } else {
            chosenTargetLang = translationManager.targetOptions[row]
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
        
            textReaderManager.generateVoice()
    }
}

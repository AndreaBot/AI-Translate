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
    
    let db = Firestore.firestore()
    
    var translationManager = TranslationManager()
    var textReaderManager = TextReaderManager()
    var player: AVAudioPlayer?
    let button = UIButton()
    
    var chosenSourceLang: String?
    var chosenTargetLang: String?
    
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
        UINavigationBar.appearance().tintColor = .white
        title = "AI Translate"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        
        if Auth.auth().currentUser != nil {
            navigationItem.hidesBackButton = true
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
        
        hearTranslationButton.tintColor = .white
        saveTranslationButton.tintColor = .white
    }
    
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segues.openMenu, sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.openMenu {
            
            let destinationVC = segue.destination as? MenuViewController
            destinationVC?.delegate = self
            
            if let sheet = destinationVC?.sheetPresentationController {
                sheet.detents = [.custom(resolver: { context in
                    return context.maximumDetentValue * 0.25
                })]
                sheet.preferredCornerRadius = 10
            }
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
            translationManager.parameters["target"] = translationManager.convertTargetLanguage(chosenTargetLang!)
            
               var parameters = self.textReaderManager.parameters
               if var voice = parameters["voice"] as? [String: String] {
                voice["languageCode"] = textReaderManager.convertVoiceLanguageCode(chosenTargetLang!)
                voice["name"] = textReaderManager.pickVoice(chosenTargetLang!)
                voice["ssmlGender"] = textReaderManager.pickGender(chosenTargetLang!)
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

// MARK: - MenuViewControllerDelegate

extension TranslatorViewController: MenuViewControllerDelegate {
    
    func goToSavedTranslations() {
        dismiss(animated: true)
        if Auth.auth().currentUser == nil {
            showAlert(with: "You need to be logged in as an user to access saved translations.")
        } else {
            performSegue(withIdentifier: K.Segues.translatorToSaved, sender: self)
        }
    }
    
    func logoutConfirmation() {
        dismiss(animated: true)
        let confirmMessage = UIAlertController(title: "Logout", message: "Are you sure you want to log out of your account?", preferredStyle: .alert)
        confirmMessage.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { logoutFunc in
            self.logoutUser()
        }))
        confirmMessage.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(confirmMessage, animated: true)
    }
    
    func logoutUser() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
           self.resetVC()
            
            

        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    func deleteConfirmation() {
        dismiss(animated: true)
        let confirmMessage = UIAlertController(title: "Delete account", message: "Are you sure you want to delete your account? This cannot be undone.", preferredStyle: .alert)
        confirmMessage.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { deleteFunc in
            self.deleteAccount()
        }))
        confirmMessage.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(confirmMessage, animated: true)
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.resetVC()
                }
            }
        }
    
    func resetVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetViewController = storyboard.instantiateViewController(withIdentifier: "UserViewController")
        let navigationController = UINavigationController(rootViewController: targetViewController)
        navigationController.modalPresentationStyle = .fullScreen
        UINavigationBar.appearance().tintColor = .black
        self.present(navigationController, animated: true, completion: nil)
    }
}



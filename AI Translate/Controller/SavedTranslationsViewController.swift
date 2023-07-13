//
//  SavedTranslationsViewController.swift
//  AI Translate
//
//  Created by Andrea Bottino on 29/06/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SavedTranslationsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let translationManager = TranslationManager()
    let db = Firestore.firestore()
    
    var translations: [Translation] = []
    
    var sourceLanguage: String?
    var sourceText: String?
    var targetLanguage: String?
    var translationText: String?
    var entryNumber: Int?
    var indexPathValue: [IndexPath]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Translations"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.TableView.translationCellNibName, bundle: nil), forCellReuseIdentifier: K.TableView.translationCellIdentifier)
        loadTranslations()
    }
    
    func loadTranslations() {
        db.collection(Auth.auth().currentUser!.uid)
            .order(by: K.Firestore.dateField, descending: true)
            .getDocuments { [self] (querySnapshot, error) in
                
                translations = []
                
                if let e = error {
                    print("the was an issue retrieving data \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let sourceLang = data[K.Firestore.sourceLanguage] as? String,
                               let originalText = data[K.Firestore.originalText] as? String,
                               let targetLang = data[K.Firestore.targetLanguage] as? String,
                               let translatedText = data[K.Firestore.translation] as? String
                            {
                                
                                let newTranslation = Translation(sourceLang: sourceLang, originalText: originalText, targetlang: targetLang, finalText: translatedText)
                                translations.append(newTranslation)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
    }
}

//MARK: - TableViewDataSource - TableViewDelegate

extension SavedTranslationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let translation = translations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.translationCellIdentifier, for: indexPath) as! TranslationCell
        cell.sourceFlag.text = translationManager.assignFlag(translation.sourceLang)
        cell.sourceText.text = translation.originalText
        cell.translationText.text = translation.finalText
        cell.targetFlag.text = translationManager.assignFlag(translation.targetlang)
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            firestoreDelete(indexPath.row, [indexPath])
            tableView.endUpdates()
        }
    }
    
    func firestoreDelete(_ indexPathRow: Int, _ indexPath: [IndexPath]) {
        translations.remove(at: indexPathRow)
        tableView.deleteRows(at: indexPath, with: .fade)
        db.collection(Auth.auth().currentUser!.uid)
            .order(by: K.Firestore.dateField, descending: true)
            .getDocuments { [self] (querySnapshot, error) in
                if let e = error {
                    print(e)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        let documentID = snapshotDocuments[indexPathRow].documentID
                        db.collection(Auth.auth().currentUser!.uid).document(documentID).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
                }
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let translation = translations[indexPath.row]
        sourceLanguage = translation.sourceLang
        sourceText = translation.originalText
        targetLanguage = translation.targetlang
        translationText = translation.finalText
        entryNumber = indexPath.row
        indexPathValue = [indexPath]
        
        performSegue(withIdentifier: K.Segues.savedToDetailed, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.savedToDetailed {
            
            let destinationVC = segue.destination as? DetailedViewController
            destinationVC?.sourceLanguage = sourceLanguage!
            destinationVC?.sourceText = sourceText
            destinationVC?.targetLanguage = targetLanguage!
            destinationVC?.translationText = translationText
            destinationVC?.indexPathRow = entryNumber
            destinationVC?.indexPathValue = indexPathValue
            destinationVC?.delegate = self
            
            if let sheet = destinationVC?.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 20
                sheet.prefersGrabberVisible = true
            }
        }
    }
}

extension SavedTranslationsViewController: DetailedViewControllerDelegate {
    func deleteFromFirestore(_ indexPathRow: Int, _ indexPath: [IndexPath]) {
        dismiss(animated: true)
        firestoreDelete(indexPathRow, indexPath)
    }
}

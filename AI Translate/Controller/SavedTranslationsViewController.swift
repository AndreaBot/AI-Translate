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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.TableView.cellNibName, bundle: nil), forCellReuseIdentifier: K.TableView.cellIdentifier)
        loadTranslations()
    }
    
    
    func loadTranslations() {
        db.collection(Auth.auth().currentUser!.uid)
            .order(by: K.Firestore.dateField, descending: true)
            .getDocuments { (querySnapshot, error) in
                
                self.translations = []
                
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
                                self.translations.append(newTranslation)
                                
                                
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.cellIdentifier, for: indexPath) as! TranslationCell
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
            translations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            db.collection(Auth.auth().currentUser!.uid)
                .getDocuments { (querySnapshot, error) in
                    if let e = error {
                        print(e)
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            let documentID = snapshotDocuments[indexPath.row].documentID
                            self.db.collection(Auth.auth().currentUser!.uid).document(documentID).delete() { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Document successfully removed!")
                                }
                            }
                        }
                    }
                }
            tableView.endUpdates()
        }
    }
}
        

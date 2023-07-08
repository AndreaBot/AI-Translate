//
//  DetailedViewController.swift
//  AI Translate
//
//  Created by Andrea Bottino on 07/07/2023.
//

import UIKit
import AVFoundation

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var sourceTitleLabel: UILabel!
    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var translationTitleLabel: UILabel!
    @IBOutlet weak var translationTextView: UITextView!
    @IBOutlet weak var hearTranslationButton: UIButton!
    @IBOutlet weak var deleteTranslationButton: UIButton!
    
    var sourceLanguage: String?
    var sourceText: String?
    var targetLanguage: String?
    var translationText: String?
    
    let translationManager = TranslationManager()
    var textReaderManager = TextReaderManager()
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTTSParameters()
        textReaderManager.delegate = self
    }
    
    
    func setUI() {
        originalTextView.layer.cornerRadius = 10
        translationTextView.layer.cornerRadius = 10
        sourceTitleLabel.text = "\(translationManager.assignFlag(sourceLanguage!)) \(sourceLanguage!)"
        originalTextView.text = sourceText
        translationTitleLabel.text = "\(translationManager.assignFlag(targetLanguage!)) \(targetLanguage!)"
        translationTextView.text = translationText
        hearTranslationButton.tintColor = .black
        deleteTranslationButton.tintColor = .black
    }
    
    func setTTSParameters() {
        var parameters = self.textReaderManager.parameters
        if var voice = parameters["voice"] as? [String: String] {
            voice["languageCode"] = textReaderManager.convertVoiceLanguageCode(targetLanguage!)
            voice["name"] = textReaderManager.pickVoice(targetLanguage!)
            voice["ssmlGender"] = textReaderManager.pickGender(targetLanguage!)
            parameters["voice"] = voice
        }
        if var input = parameters["input"] as? [String: String] {
            input["text"] = translationText
            parameters["input"] = input
        }
        self.textReaderManager.parameters = parameters
    }
    
    @IBAction func hearTranslationPressed(_ sender: UIButton) {
        textReaderManager.generateVoice()
        
    }
    
    
    @IBAction func deleteTranslationPressed(_ sender: UIButton) {
    }
}


//MARK: - TextReaderManagerDelegate

extension DetailedViewController: TextReaderManagerDelegate {
    
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
}






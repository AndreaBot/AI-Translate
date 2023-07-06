//
//  Constants.swift
//  AI Translate
//
//  Created by Andrea Bottino on 29/06/2023.
//

import Foundation

struct K {
    
    struct Segues {
        static let homeToTranslator = "continueAsGuest"
        static let registerToTranslator = "registerSuccess"
        static let loginToTranslator = "loginSuccess"
        static let translatorToSaved = "goToSavedTranslations"
    }
    
    struct TableView {
        static let cellIdentifier = "tranlsationCell"
        static let cellNibName = "TranslationCell"
    }
    
    struct Firestore {
        static let sourceLanguage = "source language"
        static let originalText = "original text"
        static let targetLanguage = "target language"
        static let translation = "translation"
    }
}

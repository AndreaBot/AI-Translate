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
        static let savedToDetailed = "goToDetailed"
        static let openMenu = "openMenu"
        static let showLoginOptions = "showLoginOptions"
        static let goToMainApp = "goToMainApp"
    }
    
    struct TableView {
        static let translationCellIdentifier = "translationCell"
        static let translationCellNibName = "TranslationCell"
    }
    
    struct Firestore {
        static let sourceLanguage = "source language"
        static let originalText = "original text"
        static let targetLanguage = "target language"
        static let translation = "translation"
        static let dateField = "date"
    }
}

//
//  TextReaderManager.swift
//  AI Translate
//
//  Created by Andrea Bottino on 23/05/2023.
//

import Foundation
import AVFoundation

protocol TextReaderManagerDelegate {
    func playAudio(_ base64String: String)
    func didFail(_ error: Error)
}

struct TextReaderManager {
    
    var delegate: TextReaderManagerDelegate?
    
    let headers = [
        "content-type": "application/json",
        "X-RapidAPI-Key": "38fde48a4dmsh982cb7ed015ff93p1529c1jsned543da8ef7a",
        "X-RapidAPI-Host": "joj-text-to-speech.p.rapidapi.com"
    ]
    var parameters = [
        "input": ["text": ""],
        "voice": [
            "languageCode": "",
            "name": "en-US-News-L",
            "ssmlGender": ""
        ],
        "audioConfig": ["audioEncoding": "MP3"]
    ] as [String : Any]
    
    
    func generateVoice() {
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://joj-text-to-speech.p.rapidapi.com/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            }
            if let safeData = data {
                let base64String = parseJSON(safeData)!
                delegate?.playAudio(base64String)
            }
        })
        dataTask.resume()
    }
                                        
    
    func parseJSON(_ readData: Data) -> String? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ReadData.self, from: readData)
            let voice = decodedData.audioContent
            return voice
            
        } catch {
            delegate?.didFail(error)
            return nil
        }
    }
    
    func convertVoiceLanguageCode(_ lang: String) -> String {
        
        switch lang {
        case "Bulgarian": return "bg-BG"
        case "Czech": return "cs-CZ"
        case "Danish": return "da-DK"
        case "German": return "de-DE"
        case "Greek": return "el-GR"
        case "English (UK)": return "en-GB"
        case "English (US)": return "en-US"
        case "Spanish": return "es-ES"
        case "Finnish": return "fi-FI"
        case "French": return "fr-FR"
        case "Hungarian": return "hu-HU"
        case "Indonesian": return "id-ID"
        case "Italian": return "it-IT"
        case "Japanese": return "ja-JP"
        case "Korean": return "ko-KR"
        case "Lithuanian": return "lt-LT"
        case "Latvian": return "lv-LV"
        case "Norwegian": return "nb-NO"
        case "Dutch": return "nl-NL"
        case "Polish": return "pl-PL"
        case "Portugese": return "pt-PT"
        case "Portugese (BR)": return "pt-BR"
        case "Romanian": return "ro-RO"
        case "Russian": return "ru-RU"
        case "Slovak": return "sk-SK"
        case "Swedish": return "sv-SE"
        case "Turkish": return "tr-TR"
        case "Ukrainian": return "uk-UA"
        case "Chinese": return "cmn-CN"
            
        default: return "en-GB"
        }
    }
    
    func pickVoice(_ lang: String) -> String {
        
        switch lang {
        case "Bulgarian": return "bg-BG-Standard-A"
        case "Czech": return "cs-CZ-Standard-A"
        case "Danish": return "da-DK-Standard-E"
        case "German": return "de-DE-Standard-C"
        case "Greek": return "el-GR-Standard-A"
        case "English (UK)": return "en-GB-Standard-C"
        case "English (US)": return "en-US-Neural2-F"
        case "Spanish": return "es-ES-Standard-C"
        case "Finnish": return "fi-FI-Standard-A"
        case "French": return "fr-FR-Neural2-C"
        case "Hungarian": return "hu-HU-Standard-A"
        case "Indonesian": return "id-ID-Standard-A"
        case "Italian": return "it-IT-Standard-A"
        case "Japanese": return "ja-JP-Standard-A"
        case "Korean": return "ko-KR-Standard-A"
        case "Lithuanian": return "lt-LT-Standard-A"
        case "Latvian": return "lv-LV-Standard-A"
        case "Norwegian": return "nb-NO-Standard-A"
        case "Dutch": return "nl-NL-Standard-A"
        case "Polish": return "pl-PL-Standard-A"
        case "Portugese": return "pt-PT-Standard-A"
        case "Portugese (BR)": return "pt-BR-Standard-A"
        case "Romanian": return "ro-RO-Standard-A"
        case "Russian": return "ru-RU-Standard-A"
        case "Slovak": return "sk-SK-Standard-A"
        case "Swedish": return "sv-SE-Standard-A"
        case "Turkish": return "tr-TR-Standard-A"
        case "Ukrainian": return "uk-UA-Standard-A"
        case "Chinese": return "cmn-CN-Standard-A"
            
        default: return "en-GB-Standard-C"
        }
    }
    
    func pickGender(_ lang: String) -> String {
        
        switch lang {
        case "Bulgarian": return "FEMALE"
        case "Czech": return "FEMALE"
        case "Danish": return "FEMALE"
        case "German": return "FEMALE"
        case "Greek": return "FEMALE"
        case "English (UK)": return "FEMALE"
        case "English (US)": return "FEMALE"
        case "Spanish": return "FEMALE"
        case "Finnish": return "FEMALE"
        case "French": return "FEMALE"
        case "Hungarian": return "FEMALE"
        case "Indonesian": return "FEMALE"
        case "Italian": return "FEMALE"
        case "Japanese": return "FEMALE"
        case "Korean": return "FEMALE"
        case "Lithuanian": return "MALE"
        case "Latvian": return "MALE"
        case "Norwegian": return "FEMALE"
        case "Dutch": return "FEMALE"
        case "Polish": return "FEMALE"
        case "Portugese": return "FEMALE"
        case "Portugese (BR)": return "FEMALE"
        case "Romanian": return "FEMALE"
        case "Russian": return "FEMALE"
        case "Slovak": return "FEMALE"
        case "Swedish": return "FEMALE"
        case "Turkish": return "FEMALE"
        case "Ukrainian": return "FEMALE"
        case "Chinese": return "FEMALE"
            
        default: return "FEMALE"
        }
    }
}


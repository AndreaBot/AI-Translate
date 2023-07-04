//
//  TranslationManager.swift
//  AITranslate
//
//  Created by Andrea Bottino on 16/05/2023.
//

import UIKit

protocol TranslationManagerDelegate {
    func showTranslation (_ translation: String)
    func didFailWithError(_ error: Error)
}

struct TranslationManager {
    
    var delegate: TranslationManagerDelegate?
    
    let headers = [
        "content-type": "application/json",
        "X-RapidAPI-Key": "38fde48a4dmsh982cb7ed015ff93p1529c1jsned543da8ef7a",
        "X-RapidAPI-Host": "deepl-translator.p.rapidapi.com"
    ]
    var parameters = [
        "text": "",
        "source": "",
        "target": ""
    ] as [String : Any]
    
    let sourceOptions = [
        "Auto", "Bulgarian","Chinese","Czech","Danish","Dutch","English","Finnish","French","German","Greek","Hungarian","Indonesian","Italian","Japanese",
        "Korean","Latvian","Lithuanian","Norwegian","Polish","Portugese","Romanian","Russian","Slovak","Spanish","Swedish","Turkish","Ukrainian"
    ]
    
    let targetOptions = [
        "🇧🇬 Bulgarian","Chinese","Czech","Danish","Dutch","English (UK)","English (US)","Finnish","French","German","Greek","Hungarian","Indonesian","Italian","Japanese",
        "Korean","Latvian","Lithuanian","Norwegian","Polish","Portugese","Portugese (BR)","Romanian","Russian","Slovak","Spanish","Swedish","Turkish","Ukrainian"
    ]
    
    func getTranslation() {
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://deepl-translator.p.rapidapi.com/translate")! as URL,
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
                let translation = parseJSON(safeData)
                delegate?.showTranslation(translation!)
            }
        })
        
        dataTask.resume()
    }
    
    
    func parseJSON(_ translationData: Data) -> String? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(TranslationData.self, from: translationData)
            let text = decodedData.text
            return text
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
    func convertSourceLanguage(_ lang: String) -> String {
        
        switch lang {
        case "Auto": return "AUTO"
        case "Bulgarian": return "BG"
        case "Czech": return "CS"
        case "Danish": return "DA"
        case "German": return "DE"
        case "Greek": return "EL"
        case "English": return "EN"
        case "Spanish": return "ES"
        case "Finnish": return "FI"
        case "French": return "FR"
        case "Hungarian": return "HU"
        case "Indonesian": return "ID"
        case "Italian": return "IT"
        case "Japanese": return "JA"
        case "Korean": return "KO"
        case "Lithuanian": return "LT"
        case "Latvian": return "LV"
        case "Norwegian": return "NB"
        case "Dutch": return "NL"
        case "Polish": return "PL"
        case "Portugese": return "PT"
        case "Romanian": return "RO"
        case "Russian": return "RU"
        case "Slovak": return "SK"
        case "Swedish": return "SV"
        case "Turkish": return "TR"
        case "Ukrainian": return "UK"
        case "Chinese": return "ZH"
            
        default: return "AUTO"
        }
    }
    
    func convertTargetLanguage(_ lang: String) -> String {
        
        switch lang {
        case "Bulgarian": return "BG"
        case "Czech": return "CS"
        case "Danish": return "DA"
        case "German": return "DE"
        case "Greek": return "EL"
        case "English": return "EN"
        case "English (UK)": return "EN-GB"
        case "English (US)": return "EN-US"
        case "Spanish": return "ES"
        case "Finnish": return "FI"
        case "French": return "FR"
        case "Hungarian": return "HU"
        case "Indonesian": return "ID"
        case "Italian": return "IT"
        case "Japanese": return "JA"
        case "Korean": return "KO"
        case "Lithuanian": return "LT"
        case "Latvian": return "LV"
        case "Norwegian": return "NB"
        case "Dutch": return "NL"
        case "Polish": return "PL"
        case "Portugese": return "PT-PT"
        case "Portugese (BR)": return "PT-BR"
        case "Romanian": return "RO"
        case "Russian": return "RU"
        case "Slovak": return "SK"
        case "Swedish": return "SV"
        case "Turkish": return "TR"
        case "Ukrainian": return "UK"
        case "Chinese": return "ZH"
            
        default: return "BG"
        }
    }
    
    func assignFlag(_ lang: String) -> String {
        
        switch lang {
        case "Bulgarian": return "🇧🇬"
        case "Czech": return "🇨🇿"
        case "Danish": return "🇩🇰"
        case "German": return "🇩🇪"
        case "Greek": return "🇬🇷"
        case "English": return "🇬🇧"
        case "English (UK)": return "🇬🇧"
        case "English (US)": return "🇺🇸"
        case "Spanish": return "🇪🇸"
        case "Finnish": return "🇫🇮"
        case "French": return "🇫🇷"
        case "Hungarian": return "🇭🇺"
        case "Indonesian": return "🇮🇩"
        case "Italian": return "🇮🇹"
        case "Japanese": return "🇯🇵"
        case "Korean": return "🇰🇷"
        case "Lithuanian": return "🇱🇹"
        case "Latvian": return "🇱🇻"
        case "Norwegian": return "🇳🇴"
        case "Dutch": return "🇳🇱"
        case "Polish": return "🇵🇱"
        case "Portugese": return "🇵🇹"
        case "Portugese (BR)": return "🇧🇷"
        case "Romanian": return "🇷🇴"
        case "Russian": return "🇷🇺"
        case "Slovak": return "🇸🇰"
        case "Swedish": return "🇸🇪"
        case "Turkish": return "🇹🇷"
        case "Ukrainian": return "🇺🇦"
        case "Chinese": return "🇨🇳"
            
        default: return ""
        }
    }
}

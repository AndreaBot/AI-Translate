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
        "Auto", "Bulgarian","Chinese","Czech","Danish","Dutch","English","Estonian","Finnish","French","German","Greek","Hungarian","Indonesia","Italian","Japanese",
        "Korean","Latvian","Lithuanian","Norwegian (Bokmål)","Polish","Portugese","Romanian","Russian","Slovak","Slovenian","Spanish","Swedish","Turkish","Ukrainian"
    ]
    
    let targetOptions = [
        "Bulgarian","Chinese","Czech","Danish","Dutch","English (British)","English (American)","German","Greek","Estonian","Finnish","French","Hungarian","Indonesia","Italian","Japanese",
        "Korean","Latvian","Lithuanian","Norwegian (Bokmål)","Polish","Portugese (all varieties)","Portugese (Brazilian)","Romanian","Russian","Slovak","Slovenian","Spanish","Swedish","Turkish","Ukrainian"
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
                //print(String(data: data!, encoding: .utf8)!)
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
    
    func convertLanguage(_ lang: String) -> String {
        switch lang {
        case "Auto":
            return "AUTO"
        case "Bulgarian":
            return "BG"
        case "Czech":
            return "CS"
        case "Danish":
            return "DA"
        case "German":
            return "DE"
        case "Greek":
            return "EL"
        case "English":
            return "EN"
        case "English (British":
            return "EN-GB"
        case "English (American)":
            return "EN-US"
        case "Spanish":
            return "ES"
        case "Estonian":
            return "ET"
        case "Finnish":
            return "FI"
        case "French":
            return "FR"
        case "Hungarian":
            return "HU"
        case "Indonesian":
            return "ID"
        case "Italian":
            return "IT"
        case "Japanese":
            return "JA"
        case "Korean":
            return "KO"
        case "Lithuanian":
            return "LT"
        case "Latvian":
            return "LV"
        case "Norwegian (Bokmål)":
            return "NB"
        case "Dutch":
            return "NL"
        case "Polish":
            return "PL"
        case "Portugese":
            return "PT"
        case "Portugese (Brazilian)":
            return "PT-BR"
        case "Portugese (all varieties)":
            return "PT-PT"
        case "Romanian":
            return "RO"
        case "Russian":
            return "RU"
        case "Slovak":
            return "SK"
        case "Slovenian":
            return "SL"
        case "Swedish":
            return "SV"
        case "Turkish":
            return "TR"
        case "Ukrainian":
            return "UK"
        case "Chinese":
            return "ZH"
            
        default:
            return "EN"
        }
    }
    
}

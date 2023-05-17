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
        "AUTO", "BG","CS","DA","DE","EL","EN","ES","ET","FI","FR","HU","ID","IT","JA",
"KO","LT","LV","NB","NL","PL","PT","RO","RU","SK","SL","SV","TR","UK","ZH"
    ]
    
    let targetOptions = [
        "BG","CS","DA","DE","EL","EN-GB","EN-US","ES","ET","FI","FR","HU","ID","IT","JA",
        "KO","LT","LV","NB","NL","PL","PT-BR","PT-PT","RO","RU","SK","SL","SV","TR","UK","ZH"
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
}


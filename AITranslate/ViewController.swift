//
//  ViewController.swift
//  Translate
//
//  Created by Andrea Bottino on 15/05/2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    let headers = [
        "content-type": "application/json",
        "X-RapidAPI-Key": "38fde48a4dmsh982cb7ed015ff93p1529c1jsned543da8ef7a",
        "X-RapidAPI-Host": "deepl-translator.p.rapidapi.com"
    ]
    let parameters = [
        "text": "Hi",
        "source": "EN",
        "target": "IT"
    ] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func translatePressed(_ sender: UIButton) {
        
        
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
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse!)
//                print(String(data: data!, encoding: .utf8)!)
                let translation = self.parseJSON(safeData)
                print(translation!)
                
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
            //delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
    
}

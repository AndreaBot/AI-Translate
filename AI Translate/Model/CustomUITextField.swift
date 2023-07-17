//
//  MyUITextField.swift
//  AI Translate
//
//  Created by Andrea Bottino on 17/07/2023.
//

import UIKit

class CustomUITextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let blueColor = CGColor(red: 0, green: 0.4, blue: 1, alpha: 1)
        textColor = .black
        borderStyle = .roundedRect
        backgroundColor = .white
        layer.cornerRadius = 7
        layer.borderColor = blueColor
        layer.borderWidth = 2
    }
}

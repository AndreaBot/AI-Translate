//
//  TranslationCell.swift
//  AI Translate
//
//  Created by Andrea Bottino on 29/06/2023.
//

import UIKit

class TranslationCell: UITableViewCell {

    @IBOutlet weak var sourceFlag: UILabel!
    @IBOutlet weak var sourceText: UILabel!
    @IBOutlet weak var translationText: UILabel!
    @IBOutlet weak var targetFlag: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        contentView.layer.borderWidth = 3
        contentView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

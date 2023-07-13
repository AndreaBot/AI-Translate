//
//  TranslationCell.swift
//  AI Translate
//
//  Created by Andrea Bottino on 29/06/2023.
//

import UIKit

class TranslationCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sourceFlag: UILabel!
    @IBOutlet weak var sourceText: UILabel!
    @IBOutlet weak var translationText: UILabel!
    @IBOutlet weak var targetFlag: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 18
        containerView.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

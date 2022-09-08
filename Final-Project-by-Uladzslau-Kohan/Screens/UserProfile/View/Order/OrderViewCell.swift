//
//  OrderViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/8/22.
//

import UIKit

class OrderViewCell: UITableViewCell {
    
    var dataName: String? {
        didSet {
            self.dataNameLabel.text = self.dataName
        }
    }
    var dataValue: String? {
        didSet {
            self.dataValueLabel.text = self.dataValue
        }
    }

    @IBOutlet private weak var dataNameLabel: UILabel!
    @IBOutlet private weak var dataValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

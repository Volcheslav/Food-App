//
//  UserProfileTableViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/1/22.
//

import UIKit

final class UserProfileTableViewCell: UITableViewCell {
   
    var cellName: String? {
        didSet {
            self.cellNameLabel.text = cellName
        }
    }
    var cellValue: String?
    
    @IBOutlet private weak var cellNameLabel: UILabel!
    @IBOutlet private weak var cellValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

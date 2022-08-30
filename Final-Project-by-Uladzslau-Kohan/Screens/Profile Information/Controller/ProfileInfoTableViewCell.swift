//
//  ProfileInfoTableViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/23/22.
//

import UIKit

final class ProfileInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameCellLabel: UILabel!
    
    @IBOutlet private weak var contentCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

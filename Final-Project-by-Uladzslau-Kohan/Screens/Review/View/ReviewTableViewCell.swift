//
//  ReviewTableViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/12/22.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet private weak var backHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cellBack: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellBack.layer.cornerRadius = 20
        self.cellBack.layer.masksToBounds = true
        self.backHeightConstraint.constant = 200
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

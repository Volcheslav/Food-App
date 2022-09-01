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
    var cellValue: String? {
        didSet {
            self.cellValueLabel.text = cellValue
        }
    }
    var editButtonTitle: String? {
        didSet {
            self.editButton.setTitle(editButtonTitle, for: .normal)
        }
    }
    var editButtonState: Bool? {
        didSet {
            self.editButton.isHidden = editButtonState ?? true
        }
    }
    
    @IBOutlet private weak var editButton: UICustomButton!
    @IBOutlet private weak var cellNameLabel: UILabel!
    @IBOutlet private weak var cellValueLabel: UILabel!
    @IBOutlet private weak var cellView: UIView!
    
    @IBAction private func editAction(_ sender: UICustomButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

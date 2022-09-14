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
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cellNameLabel: UILabel!
    @IBOutlet private weak var cellValueLabel: UILabel!
    @IBOutlet private weak var cellView: UIView!
}

//
//  OrderViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/8/22.
//

import UIKit

final class OrderViewCell: UITableViewCell {
    
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
    
}

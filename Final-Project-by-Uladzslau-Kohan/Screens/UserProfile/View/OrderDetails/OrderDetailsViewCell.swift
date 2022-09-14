//
//  OrderDetailsViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/8/22.
//

import UIKit

final class OrderDetailsViewCell: UITableViewCell {
    
    var name: String? {
        didSet {
            self.nameLabel.text = (self.name ?? "noname")§
        }
    }
    var number: String? {
        didSet {
            switch number {
            case "1":
                self.numberLabel.isHidden = true
            default:
                self.numberLabel.text = "x\(self.number ?? "no num")"
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    
}

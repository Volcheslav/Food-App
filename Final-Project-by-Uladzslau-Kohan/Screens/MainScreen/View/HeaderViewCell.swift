//
//  HeaderViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/6/22.
//

import UIKit

final class HeaderSupplementaryView: UICollectionViewCell {
    
    var name: String? {
        didSet {
            DispatchQueue.main.async {
                self.headerLabel.text = self.name
                self.headerLabel.textColor = .white
                self.headerLabel.adjustsFontSizeToFitWidth = true
            }
        }
    }

    @IBOutlet private weak var headerLabel: UILabel!
    
}

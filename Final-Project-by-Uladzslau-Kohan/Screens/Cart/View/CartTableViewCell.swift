//
//  CartTableViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    var name: String? {
        didSet {
            self.nameLabel.text = self.name
        }
    }
    var price: String? {
        didSet {
            self.priceLabel.text = self.price
        }
    }
    var imageName: String? {
        didSet {
            self.imageImView.image = UIImage(named: self.imageName ?? "no name")
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var imageImView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

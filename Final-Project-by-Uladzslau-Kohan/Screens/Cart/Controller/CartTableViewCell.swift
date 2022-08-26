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
            self.nameLabel.sizeToFit()
        }
    }
    var price: String? {
        didSet {
            self.priceLabel.text = self.price
            self.priceLabel.sizeToFit()
        }
    }
    var imageName: String? {
        didSet {
            self.imageImView.image = UIImage(named: self.imageName ?? "no name")
        }
    }
    var numberOfOrders: Int = 1 {
        didSet {
            guard self.numberOfOrders > 1  else {
                self.numberOfOrdersLabel.isHidden = true
                return
            }
            self.numberOfOrdersLabel.isHidden = false
            self.numberOfOrdersLabel.text = "x\(self.numberOfOrders)"
            
        }
    }
    
    @IBOutlet private weak var numberOfOrdersLabel: UILabel!
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

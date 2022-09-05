//
//  CartTableViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
import UIKit

final class CartTableViewCell: UITableViewCell {
    
    // MARK: Variables
    
    weak var cellDelegate: MyCellDelegate?

    var name: String? {
        didSet {
            self.nameLabel.text = (self.name ?? "noname")§
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
    
    var tagButtonAdd: Int = 0 {
        didSet {
            self.addButton.tag = tagButtonAdd
        }
    }
    
    var tagButtonRemove: Int = 0 {
        didSet {
            self.removeButton.tag = tagButtonRemove
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet private weak var numberOfOrdersLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var imageImView: UIImageView!
    
    // MARK: Actions
    
    @IBAction private func addOneAction(_ sender: UIButton) {
        guard let name = self.name,
              let price = self.price,
              let imageName = self.imageName else { return }
        cellDelegate?.didPressButtonAdd(sender.tag, name: name, price: price, imageName: imageName)
    }
    
    @IBAction private func removeOneAction(_ sender: UIButton) {
        guard let name = self.name else { return }
        cellDelegate?.didPressButtonRemove(sender.tag, name: name)
    }
    
    // MARK: LoadFunctions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

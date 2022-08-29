//
//  CartTableViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
// swiftlint: disable force_try
import RealmSwift
import UIKit

class CartTableViewCell: UITableViewCell {
    let realm = try! Realm()
    var items: Results<CartItem>!
    
    var cellDelegate: MyCellDelegate?

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
    
    @IBAction func addOneAction(_ sender: Any) {
        items = realm.objects(CartItem.self)
        guard let name = self.name,
              let imageName = self.imageName,
              let price = self.price else {
            return
        }
        let cartItem = CartItem()
        cartItem.name = name
        cartItem.imageName = imageName
        cartItem.price = Double(price)!
        try! realm.write {
            realm.add(cartItem)
        }
    }
    
    @IBAction func removeOneAction(_ sender: Any) {
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

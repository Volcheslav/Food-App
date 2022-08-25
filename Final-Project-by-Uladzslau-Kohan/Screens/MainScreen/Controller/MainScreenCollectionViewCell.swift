//
//  MainScreenCollectionViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/24/22.
//

import UIKit

class MainScreenCollectionViewCell: UICollectionViewCell {
    
    var name: String? {
        didSet {
            self.nameLabel.text = self.name
            self.nameLabel.textColor = .white
            self.addButton.layer.cornerRadius = self.addButton.frame.height / 2
            self.addButton.backgroundColor = .black
            self.addButton.tintColor = .white
        }
    }
    var price: Double? {
        didSet {
            self.priceLabel.text = String(self.price ?? 0)
            self.priceLabel.textColor = .white
        }
    }
    var nameImage: String? {
        didSet {
            guard let img = UIImage(named: self.nameImage ?? "no name") else { return }
            self.cellImage.image = img
        }
    }
    
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    @IBAction private func addToCart(_ sender: Any) {
        let cart = CartItems.shared
        guard let name = self.name,
              let imageName = self.nameImage,
              let price = self.price else {
            return
        }
        let cartItem = CartItem(name: name, price: price, imageName: imageName)
        cart.cartItems.append(cartItem)
    }
}

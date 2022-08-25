//
//  MainScreenCollectionViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/24/22.
//
//  swiftlint:disable private_outlet
import UIKit

class MainScreenCollectionViewCell: UICollectionViewCell {
    var name: String? {
        didSet {
            self.nameLabel.text = self.name
        }
    }
    var price: Double? 
    var nameImage: String? {
        didSet {
            guard let img = UIImage(named: self.nameImage ?? "no name") else { return }
            self.cellImage.image = img
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addToCart(_ sender: Any) {
    }
}
//  swiftlint:enable private_outlet

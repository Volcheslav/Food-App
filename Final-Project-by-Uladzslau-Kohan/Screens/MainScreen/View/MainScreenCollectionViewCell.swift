//
//  MainScreenCollectionViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/24/22.
import Lottie
import UIKit

final class MainScreenCollectionViewCell: UICollectionViewCell {
    
    // MARK: Variables
    
    weak var cellDelegate: MainScreenCellDelegate?
    var name: String? {
        didSet {
            self.nameLabel.text = (self.name ?? "NONAME")§
            self.nameLabel.textColor = .white
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
            DispatchQueue.main.async {
                guard let img = UIImage(named: self.nameImage ?? "no name") else { return }
                self.cellImage.image = img
            }
        }
    }
    
    var tagButtonAdd: Int = 0 {
        didSet {
            self.addLottieButton.tag = tagButtonAdd
        }
    }
    var animationName: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.addLottieButton.animation = Animation.named(self.animationName)
            }
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var addLottieButton: AnimatedButton!
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    // MARK: Actions
    
    @IBAction private func addInCart(_ sender: AnimatedButton) {
        guard let name = self.name,
              let imageName = self.nameImage,
              let price = self.price else {
            return
        }
        cellDelegate?.didPressButtonAdd(sender.tag, name: name, price: price, imageName: imageName)
    }
    }

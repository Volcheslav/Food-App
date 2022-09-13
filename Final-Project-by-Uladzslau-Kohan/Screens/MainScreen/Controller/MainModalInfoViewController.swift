//
//  MainModalInfoViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/30/22.
//

import UIKit

final class MainModalInfoViewController: UIViewController {
    
    private let alertFont: String = "Natasha"
    private let alertTitleSize: CGFloat = 23
    
    weak var controllerDelegate: MainScreenCellDelegate?
    var name: String = ""
    var price: Double = 0
    var caloreis: Int = 0
    var imageName: String = ""
    var caloriesLabelState = false

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var caloriesLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productCaloriesLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var modalView: UIView!
    @IBOutlet private weak var addToCartButton: UICustomButton!
    
    @IBAction private func addToCart(_ sender: UICustomButton) {
        self.animateButtonPush()
        controllerDelegate?.didPressModalButtonAdd(sender.tag, name: self.name, price: self.price, imageName: self.imageName)
        self.showDisaperAlert(title: "\((self.name)§) \(("ADDED")§)", font: self.alertFont, titleFontSize: self.alertTitleSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setScreenProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.addToCartButton.isHidden = ParseUserData.current == nil
    }
    
    private func animateButtonPush() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [unowned self] in
                self.addToCartButton.transform = .init(scaleX: 0.9, y: 0.8)
            },
            completion: { [unowned self] _ in
                self.addToCartButton.transform = .identity
            }
        )
    }
    
    // MARK: - Set screen properties
    
    private func setScreenProperties() {
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        self.productNameLabel.text = (name)§
        self.productPriceLabel.text = String(price)
        self.productCaloriesLabel.text = String(caloreis)
        self.productImageView.image = UIImage(named: imageName)
        self.modalView.backgroundColor = UIColor(patternImage: UIImage(named: "background") ?? .init())
        self.modalView.layer.cornerRadius = 25
        self.modalView.layer.masksToBounds = true
        self.nameLabel.text = ("MODAL_MAIN_NAME")§
        self.priceLabel.text = ("MODAL_MAIN_PRICE")§
        self.caloriesLabel.text = ("MODAL_MAIN_CALORIES")§
        self.addToCartButton.setTitle(("MODAL_MAIN_ADD_TO_CART")§, for: .normal)
        self.productCaloriesLabel.isHidden = caloriesLabelState
        self.caloriesLabel.isHidden = caloriesLabelState
    }

}

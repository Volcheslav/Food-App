//
//  MainModalInfoViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/30/22.
//

import UIKit

final class MainModalInfoViewController: UIViewController {
    
    var name: String = ""
    var price: Double = 0
    var caloreis: Int = 0
    var imageName: String = ""

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var caloriesLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productCaloriesLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var modalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false
        self.productNameLabel.text = name
        self.productPriceLabel.text = String(price)
        self.productCaloriesLabel.text = String(caloreis)
        self.productImageView.image = UIImage(named: imageName)
        self.modalView.layer.cornerRadius = 25
        self.modalView.layer.masksToBounds = true
        self.nameLabel.text = ("MODAL_MAIN_NAME")§
        self.priceLabel.text = ("MODAL_MAIN_PRICE")§
        self.caloriesLabel.text = ("MODAL_MAIN_CALORIES")§
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

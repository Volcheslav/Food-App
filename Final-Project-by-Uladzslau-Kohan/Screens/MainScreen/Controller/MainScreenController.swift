//
//  ViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/3/22.
//  swiftlint:disable force_try
import RealmSwift
import UIKit

final class MainScreenViewController: UIViewController {
    let realm = try! Realm()
    var items: Results<CartItem>!
    
    // MARK: Outlets
    
    @IBOutlet private weak var sectionNameLabel: UILabel!
    @IBOutlet private weak var mainFirstCollection: UICollectionView!
    
    // MARK: LoadFunctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = realm.objects(CartItem.self)
        self.mainFirstCollection.delegate = self
        self.mainFirstCollection.dataSource = self
        self.mainFirstCollection.backgroundColor = .lightGray
        self.mainFirstCollection.layer.cornerRadius = 20
        self.mainFirstCollection.layer.masksToBounds = true
        self.sectionNameLabel.layer.cornerRadius = 10
        self.sectionNameLabel.layer.masksToBounds = true
        self.sectionNameLabel.backgroundColor = .black
        self.sectionNameLabel.text = ("MAIN_MENU_SECTION")§
        self.sectionNameLabel.textColor = .white
        self.sectionNameLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    // MARK: RealmFunctions
    
    func addToRealm(name: String, imageName: String, price: Double ) {
        let cartItem = CartItem()
        cartItem.name = name
        cartItem.imageName = imageName
        cartItem.price = price
        try! realm.write {
            realm.add(cartItem)
        }
    }
    
    // MARK: ShowModal view controller
    
    func showModal(name:String, price: Double, calories: Int, imageName: String) {
        let storybord = UIStoryboard(name: "MainScreen", bundle: nil)
        guard let viewController = storybord.instantiateViewController(identifier: "mainModal") as? MainModalInfoViewController else {
            return
        }
        viewController.controllerDelegate = self
        viewController.name = name
        viewController.price = price
        viewController.caloreis = calories
        viewController.imageName = imageName
        viewController.modalPresentationStyle = .overCurrentContext
        show(viewController, sender: nil)
    }
    
    // MARK: Navigtion
    
    @IBAction private func goMainScreen(_ sender: UIStoryboardSegue) {
    }
}

// MARK: Cells configure

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !Menu.shared.getBurgers().isEmpty else {
            return 0
        }
        return Menu.shared.getBurgers().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainScreenCollectionViewCell
        cell.cellDelegate = self
        cell.name = Menu.shared.getBurgers()[indexPath.row].name
        cell.price = Menu.shared.getBurgers()[indexPath.row].price
        cell.nameImage = Menu.shared.getBurgers()[indexPath.row].imageName
        cell.layer.cornerRadius = 30
        cell.layer.masksToBounds = true
        cell.backgroundColor = .darkGray
        cell.tagButtonAdd = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = Menu.shared.getBurgers()[indexPath.row].name
        let price = Menu.shared.getBurgers()[indexPath.row].price
        let calories = Menu.shared.getBurgers()[indexPath.row].calories
        let imageName = Menu.shared.getBurgers()[indexPath.row].imageName
        showModal(name: name, price: price, calories: calories, imageName: imageName)
    }
    
}

// MARK: Layoyt

extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsInHeigt: CGFloat = 2
        let paddingsHeight: CGFloat = (itemsInHeigt + 1) * 10 + 1
        let avalibalHeight: CGFloat = collectionView.frame.width - paddingsHeight
        let itemWidth = avalibalHeight / itemsInHeigt
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

// MARK: CellDelegate protocol

extension MainScreenViewController: MainScreenCellDelegate {
    func didPressModalButtonAdd(_ tag: Int, name: String, price: Double, imageName: String) {
       addToRealm(name: name, imageName: imageName, price: price)
    }
    
    func didPressButtonAdd(_ tag: Int, name: String, price: Double, imageName: String) {
        addToRealm(name: name, imageName: imageName, price: price)
        ShowAlerts.showAddAlert(name: name, viewController: self)
    }
}

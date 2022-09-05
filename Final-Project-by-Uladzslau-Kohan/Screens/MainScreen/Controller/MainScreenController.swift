//
//  ViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/3/22.
//  swiftlint:disable force_try implicit_getter
import RealmSwift
import UIKit

final class MainScreenViewController: UIViewController {
    let realm = try! Realm()
    var items: Results<CartItem>!
    var plistItems: [[String:Any]]? {
        get {
            self.readFromPlist()
        }
    }
    // swiftlint:enable force_try
    // MARK: Outlets
    
    @IBOutlet private weak var sectionNameLabel: UILabel!
    @IBOutlet private weak var mainFirstCollection: UICollectionView!
    
    // MARK: - LoadFunctions
    
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
    
    // MARK: - RealmFunctions
    
    func addToRealm(name: String, imageName: String, price: Double ) {
        let cartItem = CartItem()
        cartItem.name = name
        cartItem.imageName = imageName
        cartItem.price = price
        // swiftlint:disable force_try
        try! realm.write {
            realm.add(cartItem)
        }
        // swiftlint:enable force_try
    }
    
    // MARK: - ShowModal view controller
    
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
    
    // MARK: - Navigtion
    
    @IBAction private func goMainScreen(_ sender: UIStoryboardSegue) {
    }
}

// MARK: - Cells configure

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = self.plistItems else {
            return 0
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as? MainScreenCollectionViewCell else { return .init() }
        cell.cellDelegate = self
        guard let cellData = self.plistItems else { return .init() }
        cell.name = cellData[indexPath.row]["name"] as? String
        cell.price = cellData[indexPath.row]["price"] as? Double
        cell.nameImage = cellData[indexPath.row]["imageName"] as? String
        
        cell.layer.cornerRadius = 30
        cell.layer.masksToBounds = true
        cell.backgroundColor = .darkGray
        cell.tagButtonAdd = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellData = self.plistItems else { return }
        guard let name = cellData[indexPath.row]["name"] as? String,
              let price = cellData[indexPath.row]["price"] as? Double,
              let calories = cellData[indexPath.row]["calories"] as? Int,
              let imageName = cellData[indexPath.row]["imageName"] as? String else { return }
        showModal(name: name, price: price, calories: calories, imageName: imageName)
    }
    
}

// MARK: - Layoyt

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

// MARK: - CellDelegate protocol

extension MainScreenViewController: MainScreenCellDelegate {
    func didPressModalButtonAdd(_ tag: Int, name: String, price: Double, imageName: String) {
        addToRealm(name: name, imageName: imageName, price: price)
    }
    
    func didPressButtonAdd(_ tag: Int, name: String, price: Double, imageName: String) {
        guard ParseUserData.current != nil else {
            ShowAlerts.showLoginAlert(title: ("ALERT")§, message: ("REGISTR_ALERT")§, viewController: self)
            return
        }
        addToRealm(name: name, imageName: imageName, price: price)
        ShowAlerts.showAddAlert(name: name, viewController: self)
    }
}
// swiftlint:disable force_try
// MARK: - Read from plist

extension MainScreenViewController {
    func  readFromPlist() -> [[String:Any]] {
        guard let path = Bundle.main.path(forResource: "MenuBurger", ofType: "plist") else { return [] }
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String:Any] else { return [] }
        guard let menu = plist["Menu"] as? [[String:Any]] else { return [] }
        return menu
    }
}

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
    var plistBurgerItems: [[String:Any]]? {
        get { self.readFromPlist(section: "Menu") }
    }
    var plistDrinksItems: [[String:Any]]? {
        get { self.readFromPlist(section: "Drinks") }
    }
    var plistRollItems: [[String:Any]]? {
        get { self.readFromPlist(section: "Rolls") }
    }
    var plistSnacksItems: [[String:Any]]? {
        get { self.readFromPlist(section: "Snacks") }
    }
    var plistOtherItems: [[String:Any]]? {
        get { self.readFromPlist(section: "Other") }
    }
    var plistHeaders: [String]? {
        get { self.readHeadersFromPlist() }
    }
    
    // MARK: - CompositionalLayout
    let compositionalLayout: UICollectionViewCompositionalLayout = {
        
        let fraction: CGFloat = 1 / 2
        let inset: CGFloat = 5

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset * 2, bottom: inset, trailing: inset * 2)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: 0, bottom: inset, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        
        // Header
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [headerItem]

        return UICollectionViewCompositionalLayout(section: section)

    }()

    // swiftlint:enable force_try
    // MARK: Outlets
    
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
        self.mainFirstCollection.collectionViewLayout = self.compositionalLayout
        self.mainFirstCollection.register(UINib(nibName: "HeaderSupplementaryView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "HeaderSupplementaryView")
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
    
    func showModal(name:String, price: Double, calories: Int, imageName: String, state: Bool) {
        let storybord = UIStoryboard(name: "MainScreen", bundle: nil)
        guard let viewController = storybord.instantiateViewController(identifier: "mainModal") as? MainModalInfoViewController else {
            return
        }
        viewController.controllerDelegate = self
        viewController.name = name
        viewController.price = price
        viewController.caloreis = calories
        viewController.imageName = imageName
        viewController.caloriesLabelState = state
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
        guard let sectionsNumber = self.plistHeaders?.count  else {
            return 0
        }
        return sectionsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSupplementaryView", for: indexPath) as? HeaderSupplementaryView else {
                return HeaderSupplementaryView()
            }
            
        headerView.name = (plistHeaders?[indexPath.section] ?? "noname")§
            
            return headerView
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.plistBurgerItems?.count ?? 0
        case 1:
            return self.plistDrinksItems?.count ?? 0
        case 2:
            return self.plistRollItems?.count ?? 0
        case 3:
            return self.plistSnacksItems?.count ?? 0
        case 4:
            return self.plistOtherItems?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as? MainScreenCollectionViewCell else { return .init() }
        cell.cellDelegate = self
        let cellData: [[String:Any]]
        switch indexPath.section {
        case 0:
            cellData = self.plistBurgerItems ?? []
        case 1:
             cellData = self.plistDrinksItems ?? []
        case 2:
            cellData = self.plistRollItems ?? []
        case 3:
            cellData = self.plistSnacksItems ?? []
        case 4:
            cellData = self.plistOtherItems ?? []
        default:
            return .init()
        }
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
        var cellData: [[String:Any]] = []
        switch indexPath.section {
        case 0:
            cellData = self.plistBurgerItems ?? []
        case 1:
             cellData = self.plistDrinksItems ?? []
        case 2:
            cellData = self.plistRollItems ?? []
        case 3:
            cellData = self.plistSnacksItems ?? []
        case 4:
            cellData = self.plistOtherItems ?? []
        default:
            break
        }
        let calories: Int
        let state:Bool
        if indexPath.section == 4 {
            calories = 0
            state = true
        } else {
            guard let caloriesFrom = cellData[indexPath.row]["calories"] as? Int else { return }
            calories = caloriesFrom
            state = false
        }
        guard let name = cellData[indexPath.row]["name"] as? String,
              let price = cellData[indexPath.row]["price"] as? Double,
              let imageName = cellData[indexPath.row]["imageName"] as? String else { return }
        showModal(name: name, price: price, calories: calories, imageName: imageName, state: state)
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
    func  readFromPlist(section: String) -> [[String:Any]] {
        guard let path = Bundle.main.path(forResource: "Menu", ofType: "plist") else { return [] }
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String:Any] else { return [] }
        guard let menu = plist[section] as? [[String:Any]] else { return [] }
        return menu
    }
    
    func readHeadersFromPlist() -> [String] {
        guard let path = Bundle.main.path(forResource: "Menu", ofType: "plist") else { return [] }
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String:Any] else { return [] }
        guard let headers = plist["MenuHeaders"] as? [String] else { return [] }
        return headers
    }
}

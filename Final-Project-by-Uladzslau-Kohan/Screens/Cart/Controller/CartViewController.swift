//
//  CartViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
//  swiftlint:disable force_try
import RealmSwift
import UIKit

final class CartViewController: UIViewController {
    private let cellsOnView: CGFloat = 5
    let realm = try! Realm()
    var items: Results<CartItem>!
    var order: [(CartItem, Int)]? {
        didSet {
            guard let whPrice = order.map({ $0.map { $0.0.price * Double($0.1) } })?.reduce(0, +) else { return }
            self.priceLabel.text = String(format: "%.2f", whPrice)
            self.priceLabel.sizeToFit()
        }
    }
    var wholePrice: Double?
    // MARK: - Outlets
    
    @IBOutlet private weak var greetLabel: UILabel!
    @IBOutlet private weak var cartTableView: UITableView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var deleteButton: UICustomButton!
    
    // MARK: - Actions
    @IBAction private func deleteAllAction(_ sender: UICustomButton) {
        if self.cartTableView.visibleCells.isEmpty {
            self.showEmptyCartAlert()
        } else {
            self.showClearCartAlert(tableView: self.cartTableView) }
    }
    
    // MARK: - ViewLoad functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deleteButton.setTitle(("DELETE_ALL")§, for: .normal)
        items = realm.objects(CartItem.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if ParseUserData.current != nil {
            self.greetLabel.text = "\(("ORDER")§) \(ParseUserData.current?.username ?? "")" } else {
                self.greetLabel.text = ("LOGIN_CART")§
            }
        self.getCartArray()
        self.cartTableView.reloadData()
    }
    
    func getCartArray() {
        let uniqNames = Array(Set(items.map { $0.name })).sorted()
        let count = uniqNames.map { name in
            ( items.first(where: { $0.name == name })!, items.filter { $0.name == name }.count)
        }
        self.order = count
    }
    
    // MARK: - Alert windows
    
    func showDeleteAlert(tableView: UITableView, indexPath: IndexPath, name: String) {
        let alert = UIAlertController(title: ("ALERT")§, message: ("DELETE_ALERT_MESSAGE")§, preferredStyle: .alert)
        alert.addCancelAction()
        let ok = UIAlertAction(title: ("OK")§, style: .default, handler: {[weak self] _ in
            self?.deleteFromRealmByName(name)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showClearCartAlert(tableView: UITableView) {
        let alert = UIAlertController(title: ("ALERT")§, message: ("DELETE_ALL_ALERT_MESSAGE")§, preferredStyle: .alert)
        alert.addCancelAction()
        let ok = UIAlertAction(title: ("OK")§, style: .default, handler: {[unowned self] _ in
            self.deletAllRealm()
            tableView.reloadData()
        })
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showEmptyCartAlert() {
        let alert = UIAlertController(title: ("ALERT")§, message: ("CART_IS_EMPTY")§, preferredStyle: .alert)
        alert.addCancelAction()
        self.present(alert, animated: true)
    }
    
    func deleteFromRealmByName(_ name: String) {
        try! realm.write {
            realm.delete(items.filter { $0.name == name })
        }
        self.getCartArray()
    }
    
    func deleteFromRealmOne( _ name: String) {
        guard let firstItem = items.last(where: { $0.name == name }) else { return }
        try! realm.write {
            realm.delete(firstItem)
        }
    }
    
    func deletAllRealm() {
        try! self.realm.write {
            self.realm.deleteAll()
        }
        self.getCartArray()
    }
}
// MARK: - Extension table control

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.count ?? items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as? CartTableViewCell,
              let cellOrder = order else { return .init() }
        cell.name = cellOrder[indexPath.row].0.name
        cell.price = String(format: "%.2f", cellOrder[indexPath.row].0.price * Double(cellOrder[indexPath.row].1))
        cell.imageName = cellOrder[indexPath.row].0.imageName
        cell.numberOfOrders = cellOrder[indexPath.row].1
        cell.cellDelegate = self
        cell.tagButtonAdd = indexPath.row
        cell.tagButtonRemove = -indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CartTableViewCell,
              let name = cell.name else { return }
        
        if editingStyle == .delete {
            self.showDeleteAlert(tableView: tableView, indexPath: indexPath, name: name)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (tableView.frame.height - tableView.sectionHeaderHeight - tableView.sectionFooterHeight) / cellsOnView
        return height
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ("YOUR_ORDER")§
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
}

extension CartViewController: MyCellDelegate {
    func didPressButtonRemove(_ tag: Int, name: String) {
        self.deleteFromRealmOne(name)
        self.getCartArray()
        self.cartTableView.reloadData()
        
    }
    
    func didPressButtonAdd(_ tag: Int, name: String, price: String, imageName: String) {
        let cartItem = CartItem()
        cartItem.name = name
        cartItem.imageName = imageName
        cartItem.price = Double(price)!
        try! realm.write {
            realm.add(cartItem)
        }
        self.getCartArray()
        self.cartTableView.reloadData()
    }
}

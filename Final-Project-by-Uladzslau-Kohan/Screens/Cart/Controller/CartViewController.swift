//
//  CartViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
//  swiftlint:disable force_try
import RealmSwift
import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Table constants
    
    private let cellsOnView: CGFloat = 5
    private let alertFont: String = "Natasha"
    private let alertTitleFontSize: CGFloat = 23
    private let alertMessageFontSize: CGFloat = 20
    private let cellIdentifier: String = "cartCell"
    private let headerFont: String = "Buran USSR"
    private let headerFontSize: CGFloat = 25
    private let headerHeight: CGFloat = 60
    
    let realm = try! Realm()
    var items: Results<CartItem>!
    var order: [(CartItem, Int)]? {
        didSet {
            guard let whPrice = order.map({ $0.map { $0.0.price * Double($0.1) } })?.reduce(0, +) else { return }
            self.priceLabel.text = String(format: "%.2f", whPrice)
            self.priceLabel.sizeToFit()
            self.wholePrice = whPrice
        }
    }
    var wholePrice: Double?
    // MARK: - Outlets
    
    @IBOutlet private weak var greetLabel: UILabel!
    @IBOutlet private weak var cartTableView: UITableView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var deleteButton: UICustomButton!
    @IBOutlet private weak var uploarOrderButton: UICustomButton!
    
    // MARK: - Actions
    @IBAction private func deleteAllAction(_ sender: UICustomButton) {
        self.animateButtonPush(button: sender)
        if self.cartTableView.visibleCells.isEmpty {
            self.showAlertWithCancelButn(title: "ALERT", message: "CART_IS_EMPTY", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
        } else {
            self.showClearCartAlert(tableView: self.cartTableView, title: ("ALERT")§, message: ("DELETE_ALL_ALERT_MESSAGE")§) }
    }
    
    @IBAction private func uploadOrderAction(_ sender: UICustomButton) {
        self.animateButtonPush(button: sender)
        if self.cartTableView.visibleCells.isEmpty {
            self.showAlertWithCancelButn(title: "ALERT", message: "CART_IS_EMPTY", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
        } else {
            self.sendOrder() }
        
    }
    // MARK: - ViewLoad functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartTableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        self.cartTableView.backgroundView?.alpha = 0.5
        self.deleteButton.setTitle(("DELETE_ALL")§, for: .normal)
        self.uploarOrderButton.setTitle(("UPLOAD_ORDER")§, for: .normal)
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
    
    func showDeleteAlert(tableView: UITableView, indexPath: IndexPath, name: String, title: String, message: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attributes = AppAlerts.shared.setAtributes(
            title: title,
            message: message,
            titleFont: self.alertFont,
            messageFont: self.alertFont,
            titleFontSize: self.alertTitleFontSize,
            messageFontSize: self.alertMessageFontSize
        )
        alert.setValue(attributes?.first, forKey: "attributedTitle")
        alert.setValue(attributes?.last, forKey: "attributedMessage")
        alert.addCancelAction()
        let ok = UIAlertAction(title: ("OK")§, style: .default, handler: {[weak self] _ in
            self?.deleteFromRealmByName(name)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showClearCartAlert(tableView: UITableView, title: String, message: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attributes = AppAlerts.shared.setAtributes(
            title: title,
            message: message,
            titleFont: self.alertFont,
            messageFont: self.alertFont,
            titleFontSize: self.alertTitleFontSize,
            messageFontSize: self.alertMessageFontSize
        )
        alert.setValue(attributes?.first, forKey: "attributedTitle")
        alert.setValue(attributes?.last, forKey: "attributedMessage")
        alert.addCancelAction()
        let ok = UIAlertAction(title: ("OK")§, style: .default, handler: {[unowned self] _ in
            self.deletAllRealm()
            tableView.reloadData()
        })
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    // MARK: - Realm delete functions
    
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
    
    // MARK: - Order action
    
    private func sendOrder() {
        let cartUpload = CartUpload()
        guard let stringCardNumber = ParseUserData.current?.creditCardnumder else {
            self.showAlertWithCancelButn(title: "ALERT", message: "CREDIT_ALERT", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
            return
        }
        guard let cardNumber = Int(stringCardNumber),
              let whPrice = self.wholePrice else { return }
        let orderNames = self.order.map { $0.map { "\($0.0.name) \($0.1)" } }!
        let result = cartUpload.uploadOrder(name: orderNames, price: whPrice, userName: ParseUserData.current!.username!, cardNumber: cardNumber)
        if result {
            self.showAlertWithCancelButn(title: "SUCCESS", message: "ORERD_SENT", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
            self.deletAllRealm()
            self.cartTableView.reloadData()
        } else {
            self.showAlertWithCancelButn(title: "ALERT", message: "ORDER_ERRORS", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
        }
    }
    
    // MARK: - Button animate

    private func animateButtonPush(button: UICustomButton) {
        UIView.animate(
            withDuration: 0.3,
            animations: { button.transform = .init(scaleX: 0.9, y: 0.8) },
            completion: { _ in button.transform = .identity }
        )
    }
}

// MARK: - Extension table control

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.count ?? items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as? CartTableViewCell,
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
            self.showDeleteAlert(tableView: tableView, indexPath: indexPath, name: name, title: ("ALERT")§, message: ("DELETE_ALERT_MESSAGE")§)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (tableView.frame.height - tableView.sectionHeaderHeight - tableView.sectionFooterHeight) / cellsOnView
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let label = UILabel()
        label.frame = .init(x: 0, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        DispatchQueue.main.async {
            label.text = ("YOUR_ORDER")§
        }
        label.font = UIFont(name: self.headerFont, size: self.headerFontSize)
        label.textColor = .black
        label.textAlignment = .left
        headerView.addSubview(label)
        label.center = headerView.center
        headerView.backgroundColor = .systemGray3
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
}

// MARK: - Cell delegate extension

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

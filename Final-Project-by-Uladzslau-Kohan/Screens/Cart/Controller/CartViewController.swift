//
//  CartViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
//  swiftlint:disable force_try
import RealmSwift
import UIKit

final class CartViewController: UIViewController {
    let realm = try! Realm()
    var items: Results<CartItem>!
    var order: [(CartItem, Int)]?
    // MARK: - Outlets

    @IBOutlet private weak var cartTableView: UITableView!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = realm.objects(CartItem.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCartArray()
        self.cartTableView.reloadData()
        self.priceLabel.text = String(format: "%.2f", self.items.map { $0.price }.reduce(0, +))
        self.priceLabel.sizeToFit()
        // print("\(order)\n")
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
        let alert = UIAlertController(title: "Alert!", message: "You want to delete a position on your order, are you sure?", preferredStyle: .alert)
        alert.addCancelAction()
        let ok = UIAlertAction(title: "OK", style: .default, handler: {[weak self] _ in
            self?.deleteFromRealm(indexPath, name)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self?.priceLabel.text = String(format: "%.2f", self?.items.map { $0.price }.reduce(0, +) ?? 0)
            self?.priceLabel.sizeToFit()
        })
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func deleteFromRealm(_ indexPath: IndexPath, _ name: String) {
        try! realm.write {
            //  realm.delete(items[indexPath.row])
            realm.delete(items.filter { $0.name == name })
        }
        getCartArray()
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
        let height = (tableView.frame.height - tableView.sectionHeaderHeight) / 8
        return height
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your order"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
        
}

// MARK: - Extension alert controller

extension UIAlertController {
    func addCancelAction () {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        self.addAction(cancelAction)
    }
}

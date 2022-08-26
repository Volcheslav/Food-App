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
    
    // MARK: - Outlets

    @IBOutlet private weak var cartTableView: UITableView!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = realm.objects(CartItem.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.cartTableView.reloadData()
        self.priceLabel.text = String(format: "%.2f", self.items.map { $0.price }.reduce(0, +))
        self.priceLabel.sizeToFit()
    }
    
    // MARK: - Alert windows
    
    func showDeleteAlert(tableView: UITableView, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Alert!", message: "You want to delete a position on your order, are you sure?", preferredStyle: .alert)
        alert.addCancelAction()
        let ok = UIAlertAction(title: "OK", style: .default, handler: {[weak self] _ in
            self?.deleteFromRealm(indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self?.priceLabel.text = String(format: "%.2f", self?.items.map { $0.price }.reduce(0, +) ?? 0)
            self?.priceLabel.sizeToFit()
        })
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func deleteFromRealm(_ indexPath: IndexPath) {
        try! realm.write {
            realm.delete(items[indexPath.row])
        }
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
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as? CartTableViewCell else { return .init() }
        cell.name = self.items[indexPath.row].name
        cell.price = String(self.items[indexPath.row].price)
        cell.imageName = self.items[indexPath.row].imageName
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showDeleteAlert(tableView: tableView, indexPath: indexPath)
        }
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

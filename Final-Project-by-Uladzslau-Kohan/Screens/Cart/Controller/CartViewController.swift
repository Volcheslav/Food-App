//
//  CartViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
//

import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private weak var cartTableView: UITableView!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.cartTableView.reloadData()
        self.priceLabel.text = String(format: "%.2f", CartItems.shared.totalPrice)
        self.priceLabel.sizeToFit()
    }
    
    // MARK: - Alert windows
    
    func showDeleteAlert(tableView: UITableView, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Alert!", message: "You want to delete a position on your order, are you sure?", preferredStyle: .alert)
        alert.addCancelAction()
        let ok = UIAlertAction(title: "OK", style: .default, handler: {[weak self] _ in
            CartItems.shared.cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self?.priceLabel.text = String(format: "%.2f", CartItems.shared.totalPrice)
            self?.priceLabel.sizeToFit()
        })
        alert.addAction(ok)
        self.present(alert, animated: true)
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
        return CartItems.shared.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as? CartTableViewCell else { return .init() }
        cell.name = CartItems.shared.cartItems[indexPath.row].name
        cell.price = String(CartItems.shared.cartItems[indexPath.row].price)
        cell.imageName = CartItems.shared.cartItems[indexPath.row].imageName
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showDeleteAlert(tableView: tableView, indexPath: indexPath)
        }
    }
        
}

// MARK: - Extension alert controller

extension UIAlertController {
    func addCancelAction () {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        self.addAction(cancelAction)
    }
}

//
//  UserOrdersViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/8/22.
//

import UIKit

final class UserOrdersViewController: UIViewController {
    
    var ordersData: [ParseOrder]?
    
    // MARK: - Constants
    
    private let orderNibName: String = "OrderViewCell"
    private let cellID: String = "OrderCell"
    private let ordersDetailsStoryboardName: String = "OrderDetails"
    private let ordersDetailsVCIdentifier: String = "orderDetails"
    
    // MARK: - Outlets
    
    @IBOutlet private weak var modalView: UIView!
    @IBOutlet private weak var noOrdersLabel: UILabel!
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var backButton: UICustomButton!
    @IBOutlet private weak var ordersTableView: UITableView!
    
    // MARK: - Load View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.isOpaque = false
        self.ordersTableView.backgroundView = UIImageView(image: UIImage(named: "tablePage"))
        self.ordersTableView.delegate = self
        self.ordersTableView.dataSource = self
        self.ordersTableView.register(UINib(nibName: self.orderNibName, bundle: nil), forCellReuseIdentifier: self.cellID)
        self.backButton.setTitle(("ORDERS_BACK")§, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showNoOrdersLabel()
    }
    
    private func showNoOrdersLabel() {
        guard let orders = self.ordersData else {
            self.noOrdersLabel.text = ("NO_ORDERS")§
            self.noOrdersLabel.isHidden = false
            self.backgroundImage.isHidden = false
            return
        }
        if orders.isEmpty {
            self.noOrdersLabel.text = ("NO_ORDERS")§
            self.noOrdersLabel.isHidden = false
            self.backgroundImage.isHidden = false
        } else {
            self.noOrdersLabel.isHidden = true
            self.backgroundImage.isHidden = true
        }
    }
    
    // MARK: - Show order details page
    
    private func showOrdersDetailsPage(orderData: ParseOrder) {
        let storybord = UIStoryboard(name: self.ordersDetailsStoryboardName, bundle: nil)
        guard let viewController = storybord.instantiateViewController(identifier: self.ordersDetailsVCIdentifier) as? OrderDetailsViewController else {
            return
        }
        viewController.orderData = orderData
        viewController.modalPresentationStyle = .overCurrentContext
        show(viewController, sender: nil)
        UIView.animate(withDuration: 0.6, animations: {[weak self] in
            self?.modalView.alpha = 0
        })
    }
    
    @IBAction private func goOrdersList(_ sender: UIStoryboardSegue) {
        UIView.animate(withDuration: 0.6, animations: {[weak self] in
            self?.modalView.alpha = 1
        })
    }
    
}

extension UserOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cellNumber = self.ordersData?.count  else {
            return 0
        }
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID) as? OrderViewCell,
              let order = self.ordersData,
              let date = order[indexPath.row].createdAt else { return .init() }
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd-MM-yy HH:mm"
        let formattedDateTime = dtFormatter.string(from: date)
        
        cell.dataName = "\(indexPath.row + 1). \(("DATE")§)"
        cell.dataValue = formattedDateTime
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showOrdersDetailsPage(orderData: self.ordersData?[indexPath.row] ?? .init())
    }
    
}

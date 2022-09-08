//
//  UserOrdersViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/8/22.
//

import UIKit

class UserOrdersViewController: UIViewController {
    
    // MARK: - Constants
    
    private let orderNibName: String = "OrderViewCell"
    private let cellID: String = "OrderCell"
    
    // MARK: - Outlets

    @IBOutlet private weak var backButton: UICustomButton!
    @IBOutlet private weak var ordersTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false
        self.ordersTableView.delegate = self
        self.ordersTableView.dataSource = self
        self.ordersTableView.register(UINib(nibName: self.orderNibName, bundle: nil), forCellReuseIdentifier: self.cellID)
        self.backButton.setTitle(("ORDERS_BACK")§, for: .normal)
    }
}

extension UserOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID) as? OrderViewCell else { return .init() }
        return cell
    }
    
}

//
//  OrderDetailsViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/8/22.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
    private let orderNibName: String = "OrderDetailsViewCell"
    private let cellID: String = "OrderDetailsCell"
    
    var orderData: ParseOrder?

    @IBOutlet private weak var orderDetailsTableView: UITableView!
    @IBOutlet private weak var backButtn: UICustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderDetailsTableView.delegate = self
        self.orderDetailsTableView.dataSource = self
        self.backButtn.setTitle(("ORDERS_BACK")§, for: .normal)
        self.orderDetailsTableView.register(UINib(nibName: self.orderNibName, bundle: nil), forCellReuseIdentifier: self.cellID)
    }
}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cells = self.orderData?.name?.count else {
            return 0
        }
        return cells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID) as? OrderDetailsViewCell,
              let names = self.orderData?.name else { return .init() }
        cell.name = names[indexPath.row].components(separatedBy: .whitespaces).first
        cell.number = names[indexPath.row].components(separatedBy: .whitespaces).last
        return cell
    }
    
}

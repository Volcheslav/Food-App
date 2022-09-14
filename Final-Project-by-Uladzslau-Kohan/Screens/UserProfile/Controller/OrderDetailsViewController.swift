//
//  OrderDetailsViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/8/22.
//

import UIKit

final class OrderDetailsViewController: UIViewController {
    
    private let orderNibName: String = "OrderDetailsViewCell"
    private let cellID: String = "OrderDetailsCell"
    private let tableHeaderHeight: CGFloat = 100
    private let tableFooterHeight: CGFloat = 60
    private let headerLabelFont: String = "FluorineLite"
    
    var orderData: ParseOrder?
    @IBOutlet private weak var modalView: UIView!
    @IBOutlet private weak var orderDetailsTableView: UITableView!
    @IBOutlet private weak var backButtn: UICustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderDetailsTableView.backgroundColor = .clear
        self.orderDetailsTableView.delegate = self
        self.orderDetailsTableView.dataSource = self
        self.view.backgroundColor = .clear
        self.backButtn.setTitle(("ORDERS_BACK")§, for: .normal)
        self.orderDetailsTableView.register(UINib(nibName: self.orderNibName, bundle: nil), forCellReuseIdentifier: self.cellID)
        
    }
}

// MARK: - Table extensions

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
        cell.backgroundView = UIImageView(image: UIImage(named: "cellBG"))
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    // MARK: Custon header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: self.tableHeaderHeight))
        let label = UILabel()
        let backImage = UIImageView()
        backImage.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: self.tableHeaderHeight)
        backImage.image = UIImage(named: "header")
        label.frame = .init(x: 25, y: 25, width: headerView.frame.width - 25, height: headerView.frame.height)
        label.text = ("ORDER_DETAILS")§
        label.font = UIFont(name: self.headerLabelFont, size: 36)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        headerView.addSubview(backImage)
        headerView.addSubview(label)
        headerView.backgroundColor = .clear
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableHeaderHeight
    }
    
    // MARK: - Custom footer
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let price = self.orderData?.price else { return .init() }
        let footerView = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: self.tableFooterHeight))
        let label = UILabel()
        let sumLabel = UILabel()
        let backImage = UIImageView()
        backImage.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: self.tableFooterHeight)
        backImage.image = UIImage(named: "footer")
        label.frame = .init(x: 25, y: 0, width: footerView.frame.width - 25, height: footerView.frame.height)
        label.text = ("SUM")§
        label.font = UIFont(name: self.headerLabelFont, size: 32)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        sumLabel.frame = .init(x: footerView.frame.width - 145, y: 0, width: 120, height: footerView.frame.height)
        sumLabel.text = String(format: "%.2f", price)
        sumLabel.font = UIFont(name: self.headerLabelFont, size: 28)
        sumLabel.textColor = .black
        sumLabel.textAlignment = .right
        sumLabel.numberOfLines = 1
        footerView.addSubview(backImage)
        footerView.addSubview(label)
        footerView.addSubview(sumLabel)
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.tableFooterHeight
    }
    
}

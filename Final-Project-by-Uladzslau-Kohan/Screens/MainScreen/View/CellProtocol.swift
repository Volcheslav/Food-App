//
//  CellProtocol.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
//

import UIKit

protocol CellInMainCollection {
    var mainCell: UIView! { get set }
    var cellImage: UIImageView! { get set }
    var nameLabel: UILabel! { get set }
    var addButton: UIButton! { get set }
}

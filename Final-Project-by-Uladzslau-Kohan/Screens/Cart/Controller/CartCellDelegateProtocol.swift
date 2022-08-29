//
//  CartCellDelegateProtocol.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/29/22.
//

import UIKit

protocol MyCellDelegate : class {
    func didPressButtonAdd(_ tag: Int, name: String, price: String, imageName: String)
    
    func didPressButtonRemove(_ tag: Int, name: String)
}

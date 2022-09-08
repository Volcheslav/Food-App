//
//  MainScreenCellDelegateProtocol.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/30/22.
//

import Foundation

protocol MainScreenCellDelegate : class {
    func didPressButtonAdd(_ tag: Int, name: String, price: Double, imageName: String)
    func didPressModalButtonAdd(_ tag: Int, name: String, price: Double, imageName: String)
}

//
//  MenuRealmModel.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
//

import Foundation
import RealmSwift

class CartItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var imageName: String = ""
}

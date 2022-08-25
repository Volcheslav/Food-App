//
//  MenuRealmModel.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
//

import Foundation
import RealmSwift

// class MenuModel: Object {
//    @objc dynamic var burgers: [Burgers]?
//    @objc dynamic var rolls: [Rolls]?
//    @objc dynamic var drinks: [Drinks]?
// }

class Burgers: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var imageName: String = ""
}

class Rolls: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var imageName: String = ""
}

class Drinks: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var imageName: String = ""
}

//
//  CartItems.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/25/22.
//

import Foundation

class CartItems {
    
    var cartItems:[CartItem] = []
    
    static let shared = CartItems()
    private init() {}
}

struct CartItem {
    var name: String
    var price: Double
    var imageName: String
}

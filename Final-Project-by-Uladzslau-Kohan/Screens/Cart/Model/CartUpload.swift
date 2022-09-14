//
//  CartUpload.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/7/22.
// swiftlint:disable empty_enum_arguments

import Foundation

class CartUpload {
    
    func uploadOrder(name: [String], price: Double, userName: String, cardNumber: Int) -> Bool {
        var ended = true
        guard let user = ParseUserData.current else { return false }
        let order = ParseOrder(name: name, price: price, userName: userName, cardNumber: cardNumber, userID: user.objectId)
        order.save(completion: { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                ended = false
            }
        })
        return ended
    }
}

//
//  CartUpload.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/7/22.
// swiftlint:disable empty_enum_arguments

import Foundation

class CartUpload {
    
    func uploadOrder(name: [String], price: Double, userName: String, cardNumber: Int, alert: @escaping (String, String) -> Void) -> Bool {
        var ended = true
        guard var user = ParseUserData.current else { return false }
        let order = ParseOrder(name: name, price: price, userName: userName, cardNumber: cardNumber)
        user.orders?.append(order)
        DispatchQueue.global(qos: .background).async {
            user.save(completion: { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    alert(("ALERT")§, error.message)
                    ended = false
                }
            })
        }
        DispatchQueue.global(qos: .background).async {
            order.save(completion: { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    alert(("ALERT")§, error.message)
                    ended = false
                }
            })
        }
        return ended
    }
    
}

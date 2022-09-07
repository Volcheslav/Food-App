//
//  ParseOrderData.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/7/22.
//

import Foundation
import ParseSwift

struct ParseOrder: ParseObject {
    
    // MARK: Requred data
    
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    // MARK: Order details
    var name: [String]?
    var price: Double?
}

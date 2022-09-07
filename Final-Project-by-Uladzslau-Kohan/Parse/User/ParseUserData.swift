//
//  ParseUserData.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/31/22.
//

import Foundation
import ParseSwift

struct ParseUserData: ParseUser {
    
    // MARK: ParseInfo properties required by the ParseUser protocol
    
    var authData: [String : [String : String]?]?
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    // MARK: RequredUserData
    
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    
    // MARK: AdditionalData
    
    var name: String?
    var surname: String?
    var age: UInt?
    var phoneNumber: String?
    var creditCardnumder: String?
    
    var orders: [ParseOrder]?
    
}

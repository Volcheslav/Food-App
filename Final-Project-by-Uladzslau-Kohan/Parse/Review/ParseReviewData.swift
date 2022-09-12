//
//  ParseReviewData.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/12/22.
//

import Foundation
import ParseSwift

struct ParseReviewData: ParseObject {
    
    // MARK: Requred data
    
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    // MARK: Review Details
    
    var userID: String?
    var review: String?
    var mark: Int?
}

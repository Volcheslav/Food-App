//
//  ProfileData.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/23/22.
//

import Foundation

struct ProfileData {
    
    var name: String
    var surname: String
    var email: String
    var age: UInt
    var gender: Gender
    var phoneNumber: String?
    var address: Addres
    
    enum Gender {
        case male
        case female
    }
    
    struct Addres {
        var state: String
        var city: String
        var street: String
        var houseNumber: UInt
        var flatNumber: UInt?
    }
}

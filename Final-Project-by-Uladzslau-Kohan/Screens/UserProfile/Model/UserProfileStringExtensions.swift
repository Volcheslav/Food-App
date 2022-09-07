//
//  UserProfileStringExtensions.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/2/22.
//

import Foundation

extension String {
    
    // MARK: - Email valid check
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    // MARK: - NameSurname valid check
    
    func isValidNameSurname() -> Bool {
        let nameRegEx = "[A-Za-zА-яа-я]{2,16}"
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: self)
    }
    
    func isValidAge() -> Bool {
        guard let age = Int(self) else { return false }
        return age > 5 && age < 120
    }
    
    func isValidCardNumber() -> Bool {
        guard let cardNum = Int(self) else { return false }
        return self.count == 16 && cardNum > 0
    }
    
    func isValidPhoneNumber() -> Bool {
        let phoneRegEx = "[0-9]{9,15}"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: self)
    }
}

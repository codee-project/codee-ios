//
//  Validator.swift
//  Codee
//
//  Created by Eryk on 30/07/2025.
//

import Foundation

public enum ValidatorType {
    case name
    case email
    case password
    
    case price
    case amount
    
    case phoneNumber
    case address
}

public struct Validator {
    static func isValidName(_ name: String) -> String? {
        if name.count == 0 {
            return nil
        }
        
        //        if name.count < 5 {
        //            return "Zbyt krótka nazwa"
        //        }
        
        if name.count > 40 {
            return "Zbyt długa nazwa"
        }
        
        let regex = "^[a-zA-Z0-9ąćęłńóśźżĄĆĘŁŃÓŚŹŻ\\s]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return !predicate.evaluate(with: name) ? "Niedozwolona nazwa" : nil
    }
    
    static func isValidPhoneNumber(_ name: String) -> String? {
        if name.count == 0 {
            return nil
        }
        
        if name.count < 9 {
            return "Zbyt krótki numer"
        }
        
        if name.count > 13 {
            return "Zbyt długi numer"
        }
        
        let regex = "^[0-9]{0,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return !predicate.evaluate(with: name) ? "Niedozwolona nazwa" : nil
    }
    
    static func isValidAddress(_ name: String) -> String? {
        if name.count == 0 {
            return nil
        }
        
        if name.count > 40 {
            return "Zbyt długi adres"
        }
        
        return nil
    }
    
    static func isValidEmail(_ name: String) -> String? {
        if name.count == 0 {
            return nil
        }
        
        if name.count > 40 {
            return "Zbyt długi adres email"
        }
        
        let regex = "^(?=.{1,45}$)[^\\s]{1,30}@[^\\s]{1,10}\\.[a-zA-Z]{5,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: name) ? "Błędny adres email" : nil
    }
    
    static func isValidPassword(_ name: String) -> String? {
        if name.count == 0 {
            return nil
        }
        
        
        if name.count < 8 {
            return "Zbyt krótkie hasło"
        }
        
        if name.count > 26 {
            return "Zbyt długie hasło"
        }
        
        let regex = "^[A-Za-z\\d!@#$%^&*]{8,26}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: name) ? "Hasło musi posiadać cyfre, znak specjalny, dużą i małą litere" : nil
    }
    
    static func isValidPrice(_ name: String) -> String? {
        if name.count == 0 {
            return nil
        }
        
        if name.count > 4 {
            return "Przekroczono maksymalną kwote"
        }
        
        let regex = "^[0-9]{0,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return !predicate.evaluate(with: name) ? "Możesz wprowadzić tylko cyfry" : nil
    }
    
    static func isValidAmount(_ name: String) -> String? {
        if name.count < 1 {
            return "Wprowadź wartość"
        }
        
        if name.count > 2 {
            return "Przekroczono maksymalną ilość użyć"
        }
        
        let regex = "^[0-9]{0,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return !predicate.evaluate(with: name) ? "Możesz wprowadzić tylko cyfry" : nil
    }
    
    static func isValid(for validatorType: ValidatorType, _ text: String) -> String? {
        switch validatorType {
        case .name:
            return Validator.isValidName(text)
        case .email:
            return Validator.isValidEmail(text)
        case .password:
            return Validator.isValidPassword(text)
        case .price:
            return Validator.isValidPrice(text)
        case .amount:
            return Validator.isValidAmount(text)
        case .phoneNumber:
            return Validator.isValidPhoneNumber(text)
        case .address:
            return Validator.isValidAddress(text)
        }
    }
}

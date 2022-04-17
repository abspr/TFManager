//
//  Validatable.swift
//  TFManager
//
//  Created by Hosein Abbaspour on 4/17/22.
//

import Foundation

public protocol Validatable: AnyObject {
    var rulesRepo: RulesRepo { get set }
    var textToValidate: String? { get }
    func validate() -> ValidationResult
    func didFailToValidate(_ rule: Rule)
    func didPassValidation()
}

public extension Validatable {
    func validate() -> ValidationResult {
        if rulesRepo.ignoreNil && textToValidate?.isEmpty ?? true {
            didPassValidation()
            return ValidationResult(isValid: true, message: nil)
        }
        for rule in rulesRepo.rules {
            if !rule.validate(textToValidate!) {
                didFailToValidate(rule)
                return ValidationResult(isValid: false, message: rule.message)
            }
        }
        didPassValidation()
        return ValidationResult(isValid: true, message: nil)
    }
    
    func didFailToValidate(_ rule: Rule) { }
    func didPassValidation() { }
}

//
//  Validatable.swift
//  TFManager
//
//  Created by Hosein Abbaspour on 4/17/22.
//

import Foundation

/// Adds validation to any object using `TextRulesSet` or any `TextRule`.
public protocol Validatable: AnyObject {
    
    /// Set `TextRulesRepo()` to it.
    var rulesRepo: TextRulesRepo { get set }
    
    /// Return `text` that will be validated.
    var textToValidate: String? { get }
    
    /// Don't implement this unless you know what you're doing.
    /// - Returns: Result of validation
    func validate() -> ValidationResult
    
    /// Will call when validation fails.
    func validationDidFail(_ rule: TextRule)
    
    /// Will call when validation pass.
    func validationDidPass()
}

public extension Validatable {
    func validate() -> ValidationResult {
        if rulesRepo.ignoreNil && textToValidate?.isEmpty ?? true {
            validationDidPass()
            return ValidationResult(isValid: true, message: nil)
        }
        for rule in rulesRepo.rules {
            if !rule.validate(textToValidate!) {
                validationDidFail(rule)
                return ValidationResult(isValid: false, message: rule.message)
            }
        }
        validationDidPass()
        return ValidationResult(isValid: true, message: nil)
    }
}

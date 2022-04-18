//
//  ValidationRules.swift
//  MyKuyaClient
//
//  Created by Hosein Abbaspour on 4/17/22.
//

import Foundation

/// Conform to this if you want to make your own rules beside `RulesSet`
public protocol TextRule {
    
    /// Message that will be returned if any `Validatable` field does not pass validation.
    var message: String? { get set }
    
    /// Implement this for your rule logic
    /// - Returns: `true` if `text` is valid.
    func validate(_ text: String) -> Bool
}


/// Set of rules. You can use them in  any `Validable` field.
public struct TextRulesSet {
    
    /// Mail validation using Regex.
    public static var mail: TextRule = Mail()
}

fileprivate struct Mail: TextRule {
    var message: String? = ""
    
    func validate(_ text: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return predicate.evaluate(with: text)
    }
}

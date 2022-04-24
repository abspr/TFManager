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
    var message: String { get set }
    
    /// Implement this for your rule logic
    /// - Returns: `true` if `text` is valid.
    func validate(_ text: String) -> Bool
}

/// Set of rules. You can use them in  any `Validable` field.
public struct TextRulesSet {
    
    /// Email validation. If you don't set `errorMessage` default error message will be returned.
    public static func mail(_ errorMessage: String? = nil) -> TextRule {
        if let message = errorMessage { return Mail(message) }
        else { return Mail(RulesErrorMessages.mail) }
    }
    
    /// Zipcode validation.  If you don't set `errorMessage` default error message will be returned.
    public static func zipcode(_ errorMessage: String? = nil) -> TextRule {
        if let message = errorMessage { return ZipCode(message) }
        else { return ZipCode(RulesErrorMessages.zipCode) }
    }
    
    /// Characters count validation. If you don't set `errorMessage` default error message will be returned.
    public static func exactLenght(_ lenght: Int, _ errorMessage: String? = nil) -> TextRule {
        if let message = errorMessage { return ExactLenght(lenght: lenght, message) }
        else { return ExactLenght(lenght: lenght, RulesErrorMessages.exactLenght(lenght)) }
    }
    
    /// Minimum characters count validation. If you don't set `errorMessage` default error message will be returned.
    public static func minLenght(_ lenght: Int, _ errorMessage: String? = nil) -> TextRule {
        if let message = errorMessage { return MinLenght(minLenght: lenght, message) }
        else { return MinLenght(minLenght: lenght, RulesErrorMessages.minLenght(lenght)) }
    }
    
    /// Maximum characters count validation. If you don't set `errorMessage` default error message will be returned.
    public static func maxLenght(_ lenght: Int, _ errorMessage: String? = nil) -> TextRule {
        if let message = errorMessage { return MaxLenght(maxLenght: lenght, message) }
        else { return MaxLenght(maxLenght: lenght, RulesErrorMessages.maxLenght(lenght)) }
    }
    
    /// If text is only white spaces will not pass validation. If you don't set `errorMessage` default error message will be returned.
    public static func notEmpty(_ errorMessage: String? = nil) -> TextRule {
        if let message = errorMessage { return notEmpty(message) }
        else { return NotEmpty(RulesErrorMessages.notEmpty) }
    }
    
    /// Validates if text cotains only numbers.  If you don't set `errorMessage` default error message will be returned.
    public static func numbersOnly(_ errorMessage: String? = nil) -> TextRule {
        if let message = errorMessage { return NumbersOnly(message) }
        else { return NumbersOnly(RulesErrorMessages.numbersOnly) }
    }
    
}

/// Implement this on your object and pass the regex and use `validate(_:)` for validation.
public protocol RegexRuleInterface {
    var regex: String { get }
    func validate(_ text: String) -> Bool
}

extension RegexRuleInterface {
    func validate(_ text: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
}

fileprivate struct RulesErrorMessages {
    static var mail: String = "Email is not valid."
    static var zipCode: String = "Zipcode is not valid."
    static var notEmpty: String = "Space only text is not valid."
    static var numbersOnly: String = "You must enter only numbers."
    static func exactLenght(_ lenght: Int) -> String { "Must be exactly \(lenght) characters long." }
    static func minLenght(_ lenght: Int) -> String { "Must be at least \(lenght) characters long." }
    static func maxLenght(_ lenght: Int) -> String { "Must be maximum of \(lenght) characters long." }
}

fileprivate struct Mail: TextRule, RegexRuleInterface {
    var regex: String { "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" }
    var message: String
    
    init(_ errorMessage: String) { message = errorMessage }
}

fileprivate struct ZipCode: TextRule, RegexRuleInterface {
    var regex: String { "\\d{5}(-\\d{4})?" }
    var message: String
    
    init(_ errorMessage: String) { message = errorMessage }
}

fileprivate struct ExactLenght: TextRule {
    var message: String
    var lenght: Int
    
    init(lenght: Int, _ errorMessage: String) {
        self.lenght = lenght
        message = errorMessage
    }
    
    func validate(_ text: String) -> Bool {
        text.count == lenght
    }
}

fileprivate struct MinLenght: TextRule {
    var message: String
    var min: Int
    
    init(minLenght: Int, _ errorMessage: String) {
        self.min = minLenght
        message = errorMessage
    }
    
    func validate(_ text: String) -> Bool {
        text.count >= min
    }
}

fileprivate struct MaxLenght: TextRule {
    var message: String
    var max: Int
    
    init(maxLenght: Int, _ errorMessage: String) {
        self.max = maxLenght
        message = errorMessage
    }
    
    func validate(_ text: String) -> Bool {
        text.count <= max
    }
}


fileprivate struct NotEmpty: TextRule {
    var message: String
    
    init(_ errorMessage: String) {
        message = errorMessage
    }
    
    func validate(_ text: String) -> Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
}

fileprivate struct NumbersOnly: TextRule {
    var message: String
    
    init(_ errorMessage: String) {
        message = errorMessage
    }
    
    func validate(_ text: String) -> Bool {
        var isValid = true
        text.unicodeScalars.forEach { scalar in
            if !CharacterSet.decimalDigits.contains(scalar) {
                isValid = false
                return
            }
        }
        return isValid
    }
}

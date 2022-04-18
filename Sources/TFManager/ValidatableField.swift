//
//  ValidatableField.swift
//  MyKuyaClient
//
//  Created by Hosein Abbaspour on 4/17/22.
//

import UIKit

/// A subclass of `UITextField` supports validation.
///
/// You can add rules like this:
/// ```swift
/// yourField.rulesRepo.add(TextRulesSet.mail)
/// ```
/// ---
/// If you use your custom `UITextField` make sure subclass from `ValidatableField` and if you have a custom `UIControl` it should conforms to `Validatable` protocol.
///
open class ValidatableField: UITextField, Validatable {
  
    /// You add or remove rules using this property. Use `RulesSet` for some default rules or add your own using `Rule` protocol.
    public var rulesRepo = TextRulesRepo()
    
    /// Returns `text` property of `UITextField`
    public var textToValidate: String? { text }

}

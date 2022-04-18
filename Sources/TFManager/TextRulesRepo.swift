//
//  RulesRepo.swift
//  TFManager
//
//  Created by Hosein Abbaspour on 4/17/22.
//

import Foundation

/// An object holds all rules.
public class TextRulesRepo: NSObject {
    
    /// Array of rules
    public var rules: [TextRule] = []
    
    /// If sets to `true` it will pass validation if `text` is `nil`
    public var ignoreNil: Bool = false
    
    /// Add rule using this. You can use `RulesSet` for preset rules.
    /// - Parameter rule: Use `RulesSet` for preset or extent it for your own rules.
    public func add(_ rule: TextRule) {
        rules.append(rule)
    }
    
    /// Remove all rules set before using `add(_:)` method.
    public func removeAllRules() {
        rules.removeAll()
    }
}

//
//  RulesRepo.swift
//  TFManager
//
//  Created by Hosein Abbaspour on 4/17/22.
//

import Foundation

public class RulesRepo: NSObject {
    public var rules: [Rule] = []
    public var ignoreNil: Bool = false
    
    public func add(_ rule: Rule) {
        rules.append(rule)
    }
    
    public func removeAllRules() {
        rules.removeAll()
    }
}

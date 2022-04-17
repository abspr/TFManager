//
//  ValidationRules.swift
//  MyKuyaClient
//
//  Created by Hosein Abbaspoor on 2/7/1400 AP.
//  Copyright © 1400 AP machine.ventures. All rights reserved.
//

import Foundation

public protocol Rule {
    var message: String? { get set }
    func validate(_ text: String) -> Bool
}

public struct RulesSet {
    public static var mail: Rule = MailRule()
}

struct MailRule: Rule {
    var message: String? = ""
    
    func validate(_ text: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return predicate.evaluate(with: text)
    }
}

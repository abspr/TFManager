//
//  ValidationResult.swift
//  TFManager
//
//  Created by Hosein Abbaspour on 4/17/22.
//

import Foundation

/// Result object used in `Validatable` and `TFManager`
public struct ValidationResult {
    
    /// Boolean determines whether validatoin did pass or not.
    public var isValid: Bool
    
    /// holds error message.
    public var message: String?
}

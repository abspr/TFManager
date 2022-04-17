//
//  ValidatableField.swift
//  MyKuyaClient
//
//  Created by Hosein Abbaspoor on 2/8/1400 AP.
//  Copyright © 1400 AP machine.ventures. All rights reserved.
//

import UIKit

open class ValidatableField: UITextField, Validatable {
  
    public var rulesRepo = RulesRepo()
    public var textToValidate: String? { text }

}

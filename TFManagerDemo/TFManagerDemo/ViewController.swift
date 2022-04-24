//
//  ViewController.swift
//  TFManagerDemo
//
//  Created by Hosein Abbaspour on 4/16/22.
//

import UIKit
import TFManager

class ViewController: UITableViewController {
    
    var fieldsManager = TFManager()
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var mailField: ValidatableField! {
        didSet {
            mailField.rulesRepo.add(TextRulesSet.mail())
        }
    }
    
    @IBOutlet weak var ageField: CustomValidatableField! {
        didSet {
            ageField.rulesRepo.ignoreNil = true
            ageField.rulesRepo.add(TextRulesSet.numbersOnly())
            ageField.rulesRepo.add(TextRulesSet.minLenght(1))
            ageField.rulesRepo.add(TextRulesSet.maxLenght(2))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldsManager.add([nameField, mailField, ageField])
        fieldsManager.delegate = self
    }

}

extension ViewController: TFManagerDelegate {
    
    func textDidChange(_ textField: UITextField, validationResult: ValidationResult?) {
        guard let validationResult = validationResult, textField == mailField else { return }
        textField.textColor = validationResult.isValid ? .label : .systemRed
    }

}

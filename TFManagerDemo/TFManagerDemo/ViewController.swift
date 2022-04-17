//
//  ViewController.swift
//  TFManagerDemo
//
//  Created by Hosein Abbaspour on 4/16/22.
//

import UIKit
import TFManager

class ViewController: UITableViewController {
    
    var form = TFManager()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    @IBOutlet weak var mailField: ValidatableField! {
        didSet {
            mailField.rulesRepo.add(RulesSet.mail)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form.add([nameField, mailField, ageField])
        form.delegate = self
    }

}

extension ViewController: FormDelegate {
    
    func textDidChange(_ textField: UITextField, validationResult: ValidationResult?) {
        guard let validationResult = validationResult else { return }
        textField.textColor = validationResult.isValid ? .label : .systemRed
    }
}

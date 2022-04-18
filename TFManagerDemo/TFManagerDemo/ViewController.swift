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
            mailField.rulesRepo.add(TextRulesSet.mail)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form.add([nameField, mailField, ageField])
        form.delegate = self
    }

}

extension ViewController: TFManagerDelegate {
    
    func textDidChange(_ textField: UITextField, validationResult: ValidationResult?) {
        print("change", textField.text)
        guard let validationResult = validationResult else { return }
        textField.textColor = validationResult.isValid ? .label : .systemRed
    }
    
    func focusChanged(from textField: UITextField) {
        print("from", textField.text)
    }
    
    func focusChanged(to textField: UITextField) {
        print("to", textField.text)
    }
    
    func didEndEditing(_ manager: TFManager) {
        print("end")
    }
}

//
//  Form.swift
//  TFManager
//
//  Created by Hosein Abbaspour on 4/17/22.
//

import Foundation

public protocol FormDelegate: AnyObject {
    func formFocusChanged(from textField: UITextField)
    func formFocusChanged(to textField: UITextField)
    func textDidChange(_ textField: UITextField, validationResult: ValidationResult?)
    func formDidEndEditing(_ manager: TFManager)
}

public extension FormDelegate {
    func formFocusChanged(from textField: UITextField) { }
    func formFocusChanged(to textField: UITextField) { }
    func textDidChange(_ textField: UITextField, validationResult: ValidationResult?) { }
    func formDidEndEditing(_ manager: TFManager) { }
}


/// Groups textFields together and handle their navigation.
open class TFManager: NSObject {
    
    
    /// Methods related to textFields focus and their validation status.
    public weak var delegate: FormDelegate?
    
    private var items: [UITextField] = []
    
    private lazy var prevButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.style = .plain
        button.target = self
        button.action = #selector(goToPreviousField(_:))
        if #available(iOS 13.0, *) {
            button.image = UIImage(systemName: "chevron.backward")
        } else {
            button.title = "Previous"
        }
        return button
    }()
    
    private lazy var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.style = .plain
        button.target = self
        if #available(iOS 13.0, *) {
            button.image = UIImage(systemName: "chevron.right")
        } else {
            button.title = "Next"
        }
        button.action = #selector(goToNextField(_:))
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction(_:)))
        return button
    }()
    
    private lazy var toolbar = UIToolbar()
    private var activeField: UITextField?
    private var hasToolbar: Bool = true
    
    // MARK: - Init and setup
    
    public override init() {
        super.init()
    }
    
    private func setupToolbar() {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([prevButton, nextButton, space, doneButton], animated: false)
        toolbar.sizeToFit()
    }
    
    private func configFields() {
        for (index, field) in items.enumerated() {
            field.addTarget(self, action: #selector(fieldTextChanged(_:)), for: .editingChanged)
            field.addTarget(self, action: #selector(fieldBeginEditing(_:)), for: .editingDidBegin)
            field.addTarget(self, action: #selector(returnDidPress(_:)), for: .editingDidEndOnExit)
            let isLastField = index == items.count - 1
            field.returnKeyType = isLastField ? .done : .next
        }
    }
    
    // MARK: - Public
    
    
    /// Adds array of textFields in order of their appearance.
    /// - Parameters:
    ///   - fields:
    ///   - includesBar:
    open func add(_ fields: [UITextField], includesBar: Bool = true) {
        items = fields
        hasToolbar = includesBar
        configFields()
        if hasToolbar { setupToolbar() }
    }
    
    // MARK: - Actions
    
    @objc
    private func goToNextField(_ textField: UITextField) {
        guard let lastField = items.last,  textField != lastField else { return }
        guard let activeField = activeField else { return }
        guard let activeFieldIndex = items.firstIndex(where: { $0 == activeField }) else { return }
        if items.indices.contains(activeFieldIndex + 1) {
            items[activeFieldIndex + 1].becomeFirstResponder()
        }
    }
    
    @objc
    private func goToPreviousField(_ textField: UITextField) {
        guard let firstField = items.first,  textField != firstField else { return }
        guard let activeField = activeField else { return }
        guard let activeFieldIndex = items.firstIndex(where: { $0 == activeField }) else { return }
        if items.indices.contains(activeFieldIndex - 1) {
            items[activeFieldIndex - 1].becomeFirstResponder()
        }
    }
    
    @objc
    private func doneAction(_ textField: UITextField) {
        activeField?.resignFirstResponder()
        delegate?.formDidEndEditing(self)
    }
    
    @objc
    private func fieldTextChanged(_ textField: UITextField) {
        delegate?.textDidChange(textField, validationResult: (textField as? ValidatableField)?.validate())
    }
    
    @objc
    private func fieldBeginEditing(_ textField: UITextField) {
        activeField = textField
        guard hasToolbar else { return }
        activeField?.inputAccessoryView = toolbar
        nextButton.isEnabled = !(textField == items.last)
        prevButton.isEnabled = !(textField == items.first)
    }
    
    @objc
    private func returnDidPress(_ textField: UITextField) {
        if textField == items.last {
            doneAction(textField)
        } else {
            goToNextField(textField)
        }
    }
    
    // MARK: -
    
    /// Loop through all textFields in the manager and returns the result.
    /// - Returns: Array of tuples containing textFields and validation result.
    public func validate() -> [(textField: UITextField, result: ValidationResult)] {
        var validationResult = [(textField: UITextField, result: ValidationResult)]()
        for item in items {
            guard let validatableItem = item as? Validatable else { continue }
            let result = validatableItem.validate()
            if !result.isValid {
                validationResult.append((item, result))
            }
        }
        return validationResult
    }
    

    
}

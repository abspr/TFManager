//
//  Form.swift
//  TFManager
//
//  Created by Hosein Abbaspour on 4/17/22.
//

import UIKit

/// Sets of methods you can use to notify how users are interacting with the textFields.
public protocol TFManagerDelegate: AnyObject {
    
    /// to notify which `UITextField` was last responder.
    func focusChanged(from textField: UITextField)
    
    /// to notify which `UITextField` became first responder.
    func focusChanged(to textField: UITextField)
    
    /// Will call when text changed from a `UITextField` with its validation result.
    func textDidChange(_ textField: UITextField, validationResult: ValidationResult?)
    
    /// Will call when no more `UITextField` is first responder.
    func didEndEditing(_ manager: TFManager)
}

public extension TFManagerDelegate {
    func focusChanged(from textField: UITextField) { }
    func focusChanged(to textField: UITextField) { }
    func textDidChange(_ textField: UITextField, validationResult: ValidationResult?) { }
    func didEndEditing(_ manager: TFManager) { }
}


/// Groups textFields together and handle their navigation.
open class TFManager: NSObject {
    
    
    /// Use this to get notified how users are interacting with the textFields
    public weak var delegate: TFManagerDelegate?
    
    private var items: [UITextField] = []
    
    private lazy var prevButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.style = .plain
        button.target = self
        button.action = #selector(goToPreviousField)
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
        button.action = #selector(goToNextField)
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
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
            field.addTarget(self, action: #selector(fieldEndsEditing(_:)), for: .editingDidEnd)
            let isLastField = index == items.count - 1
            field.returnKeyType = isLastField ? .done : .next
        }
    }
    
    // MARK: - Public
    
    
    /// Adds array of textFields in order of their appearance.
    /// - Parameters:
    ///   - fields: Array of `UITextFields` or `Validable` field.
    ///   - includesBar: Whether keyboard should have accessory bar or not.
    open func add(_ fields: [UITextField], includesBar: Bool = true) {
        items = fields
        hasToolbar = includesBar
        configFields()
        if hasToolbar { setupToolbar() }
    }
    
    // MARK: - Actions
    
    @objc
    private func goToNextField() {
        guard let activeField = activeField else { return }
        guard let lastField = items.last, activeField != lastField else { return }
        guard let activeFieldIndex = items.firstIndex(where: { $0 == activeField }) else { return }
        if items.indices.contains(activeFieldIndex + 1) {
            items[activeFieldIndex + 1].becomeFirstResponder()
        }
    }
    
    @objc
    private func goToPreviousField() {
        guard let activeField = activeField else { return }
        guard let firstField = items.first,  activeField != firstField else { return }
        guard let activeFieldIndex = items.firstIndex(where: { $0 == activeField }) else { return }
        if items.indices.contains(activeFieldIndex - 1) {
            items[activeFieldIndex - 1].becomeFirstResponder()
        }
    }
    
    @objc
    private func doneAction() {
        activeField?.resignFirstResponder()
        delegate?.didEndEditing(self)
    }
    
    @objc
    private func fieldTextChanged(_ textField: UITextField) {
        delegate?.textDidChange(textField, validationResult: (textField as? ValidatableField)?.validate())
    }
    
    @objc
    private func fieldBeginEditing(_ textField: UITextField) {
        activeField = textField
        delegate?.focusChanged(to: textField)
        guard hasToolbar else { return }
        activeField?.inputAccessoryView = toolbar
        nextButton.isEnabled = !(textField == items.last)
        prevButton.isEnabled = !(textField == items.first)
    }
    
    @objc
    private func fieldEndsEditing(_ textField: UITextField) {
        delegate?.focusChanged(from: textField)
    }
    
    @objc
    private func returnDidPress(_ textField: UITextField) {
        if textField == items.last {
            doneAction()
        } else {
            goToNextField()
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

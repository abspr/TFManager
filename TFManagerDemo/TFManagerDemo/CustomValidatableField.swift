//
//  CustomValidatableField.swift
//  TFManagerDemo
//
//  Created by Hosein Abbaspour on 4/24/22.
//

import TFManager

class CustomValidatableField: ValidatableField {
    
    private lazy var errorImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .systemRed
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        rightViewMode = .always
        rightView = errorImageView
    }
    
    // from Validatable protocol:
    
    override func validationDidPass() {
        errorImageView.image = nil
    }
    
    override func validationDidFail(_ rule: TextRule) {
        errorImageView.image = UIImage(systemName: "exclamationmark.circle")
    }
    
}

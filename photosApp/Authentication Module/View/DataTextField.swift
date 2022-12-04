//
//  DataTextField.swift
//  photosApp
//
//  Created by Юрий on 05.12.2022.
//
import UIKit

class DataTextField: UITextField {
    
    var field: Resources.Fields?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        borderStyle = .line
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.borderColor = UIColor.gray.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        rightViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


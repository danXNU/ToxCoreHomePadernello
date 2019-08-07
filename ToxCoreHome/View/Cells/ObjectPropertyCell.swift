//
//  ObjectPropertyCell.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 16/08/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class ObjectPropertyCell: UITableViewCell {

    var objectProperty : ToxObjectProperty? {
        didSet {
            guard let property = objectProperty else { return }
            DispatchQueue.main.async {
                self.propertyNameLabel.text = property.propertyName
                guard let value = property.value.value?.get() else { return }
                if let strValue = value as? String {
                    self.valueTextField.text = strValue
                } else {
                    self.valueTextField.text = String(describing: value)
                }
            }
        }
    }
    
    let propertyNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(propertyNameLabel)
        addSubview(valueTextField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        propertyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        propertyNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        propertyNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        propertyNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9).isActive = true
        
        valueTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        valueTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        valueTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9).isActive = true
        valueTextField.leadingAnchor.constraint(equalTo: propertyNameLabel.trailingAnchor, constant: 5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

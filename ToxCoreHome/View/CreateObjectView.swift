//
//  CreateObjectView.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 06/08/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class CreateObjectView: UIView {

    let nomeField : UITextField = {
        let field = UITextField()
        field.placeholder = "Nome Oggetto"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        return field
    }()
    
    let descriptionField : UITextField = {
        let field = UITextField()
        field.placeholder = "Descrizione dell'oggetto"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        return field
    }()
    
    let initialClassButtonTitle = "Tipo di Oggetto"
    let classButton : ListButton = {
        let button = ListButton()
        button.setTitle("Tipo di Oggetto", for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    
    
    let createButton : UIButton = {
        let button = UIButton()
        button.setTitle("Crea", for: .normal)
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    
    let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        
        
        addSubview(nomeField)
        addSubview(descriptionField)
        addSubview(createButton)
        addSubview(stackView)
        addSubview(classButton)
        
        bringSubviewToFront(classButton)
        
        [classButton, nomeField, descriptionField, createButton].forEach({ stackView.addArrangedSubview($0) })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("View Initialized from coder")
    }
}

//
//  AddHandlerView.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 03/08/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class AddHandlerView: UIView {

    let handlerKeyButton : DropDownButton = {
        let b = DropDownButton()
        return b
    }()
    
    let objectToAddButton : DropDownButton = {
        let b = DropDownButton()
        return b
    }()
    
    let messageObjectToAddButton : DropDownButton = {
        let b = DropDownButton()
        return b
    }()
    
    let addHandlerButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Aggiungi", for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    
    var dropButtons : [DropDownButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(addHandlerButton)
        
        addSubview(handlerKeyButton)
        addSubview(objectToAddButton)
        addSubview(messageObjectToAddButton)
        
        
        
        dropButtons = [handlerKeyButton, objectToAddButton, messageObjectToAddButton]
        dropButtons.forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dropButtons.forEach({ $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true })
        dropButtons.forEach({ $0.heightAnchor.constraint(equalToConstant: 60).isActive = true })
        dropButtons.forEach({ $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true })
        handlerKeyButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        objectToAddButton.topAnchor.constraint(equalTo: handlerKeyButton.bottomAnchor, constant: 50).isActive = true
        messageObjectToAddButton.topAnchor.constraint(equalTo: objectToAddButton.bottomAnchor, constant: 50).isActive = true
        
        
        addHandlerButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addHandlerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addHandlerButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        addHandlerButton.topAnchor.constraint(equalTo: messageObjectToAddButton.bottomAnchor, constant: 150).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

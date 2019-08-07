//
//  ToxHandlerCell.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 02/08/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class ToxHandlerCell: UITableViewCell {

    var handler : ToxHandler? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let handler = self?.handler else { return }
                self?.titleLabel.text = "Handler"
                self?.functionNameLabel.text = "Funzione svolta --> (\(handler.function.objectName ?? "NULL")).\(handler.function.functionName)"
            }
        }
    }
    
    
    let boxView : UIView = {
        let boxView = UIView()
        boxView.backgroundColor = UIColor.black.lighter(by: 10)
        boxView.layer.cornerRadius = 10
        boxView.translatesAutoresizingMaskIntoConstraints = false
        return boxView
    }()
    
    let titleLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .red
        return l
    }()
    
    
    let removeButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Modifica", for: .normal)
        return b
    }()
    
    let bottomLine : UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .white
        return line
    }()
    
    let functionNameLabel : UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let spaceView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(boxView)
        boxView.addSubview(titleLabel)
        boxView.addSubview(removeButton)
        boxView.addSubview(bottomLine)
        boxView.addSubview(functionNameLabel)
        boxView.addSubview(spaceView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        boxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        boxView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        boxView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        boxView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: boxView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        removeButton.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        removeButton.bottomAnchor.constraint(equalTo: boxView.bottomAnchor).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomLine.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: removeButton.topAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        spaceView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        spaceView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        spaceView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        spaceView.bottomAnchor.constraint(equalTo: bottomLine.topAnchor).isActive = true
        
        functionNameLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10).isActive = true
        functionNameLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -10).isActive = true
        functionNameLabel.centerYAnchor.constraint(equalTo: spaceView.centerYAnchor, constant: 0).isActive = true
        functionNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

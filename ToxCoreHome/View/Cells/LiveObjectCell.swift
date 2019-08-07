//
//  LiveObjectCell.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 06/09/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class LiveObjectCell: UITableViewCell {

    var objectOfCell : ToxObject? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.mainLabel.text = "Oggetto: \(self?.objectOfCell?.name ?? "NULL")"
                self?.secondLabel.text = "Valore Live: \(self?.objectOfCell?.liveProperty ?? "NULL")"
            }
        }
    }
    
    let boxView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.lighter(by: 7)
        view.layer.cornerRadius = 7
        return view
    }()
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        return label
    }()
    
    let secondLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        return label
    }()
    
    let stackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        stackView.addArrangedSubview(mainLabel)
        stackView.addArrangedSubview(secondLabel)
        
        addSubview(boxView)
        boxView.addSubview(stackView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        boxView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        boxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        boxView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        boxView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalTo: boxView.heightAnchor, multiplier: 0.9).isActive = true
        stackView.centerYAnchor.constraint(equalTo: boxView.centerYAnchor).isActive = true
        
        
    }
    
}

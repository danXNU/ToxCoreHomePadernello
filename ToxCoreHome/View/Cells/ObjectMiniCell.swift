//
//  ObjectMiniCell.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 02/09/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class ObjectMiniCell: UITableViewCell {

    var objectOfCell : ToxObject?
    
    let boxView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.lighter(by: 7)
        view.layer.cornerRadius = 7
        return view
    }()
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        addSubview(boxView)
        boxView.addSubview(mainLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        boxView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        boxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        boxView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        boxView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        mainLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10).isActive = true
        mainLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -10).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: boxView.centerYAnchor).isActive = true
        mainLabel.heightAnchor.constraint(equalTo: boxView.heightAnchor, multiplier: 0.75).isActive = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SiriShortcutCell : ObjectMiniCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
}

//
//  SiriView.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 04/09/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class SiriView: UIView {

    let tableView : UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.tableFooterView = UIView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

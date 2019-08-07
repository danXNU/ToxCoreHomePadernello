//
//  ChangeObjectPropertiesView.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 16/08/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class ChangeObjectPropertiesView: UIView {

    let tableView : UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView()
        return table
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray.lighter()
        
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

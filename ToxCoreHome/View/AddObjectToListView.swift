//
//  AddObjectToListView.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 02/09/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class AddObjectToListView: UIView {

    let refreshCotrol = UIRefreshControl()
    let tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView()
        table.backgroundColor = .clear
        table.allowsMultipleSelection = true
        table.separatorStyle = .none
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.refreshControl = refreshCotrol
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

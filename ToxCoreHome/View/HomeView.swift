//
//  HomeView.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 31/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class HomeView: UIView {

    let refreshControl = UIRefreshControl()
    
    let tableView : UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        return table
    }()
    
    let objectChoiceSegment : UISegmentedControl = {
        let seg = UISegmentedControl()
        seg.insertSegment(withTitle: "Oggetti", at: 0, animated: true)
        seg.insertSegment(withTitle: "Azioni", at: 1, animated: true)
        seg.selectedSegmentIndex = 0
        seg.translatesAutoresizingMaskIntoConstraints = false
        return seg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(objectChoiceSegment)
        self.addSubview(tableView)
        
        tableView.refreshControl = refreshControl
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        objectChoiceSegment.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        objectChoiceSegment.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        objectChoiceSegment.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        objectChoiceSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: objectChoiceSegment.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

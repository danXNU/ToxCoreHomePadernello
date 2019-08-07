//
//  ListButton.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 19/09/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class ListButton: UIButton {

    var options : [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

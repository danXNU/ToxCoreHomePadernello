//
//  ToxError.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 30/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

enum ToxError : Error  {
    case invalidResponseMessage(msg: String)
    case inconsistencyLocalError(msg: String)
    case localError(msg: String)
}

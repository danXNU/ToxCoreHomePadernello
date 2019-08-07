//
//  ToxResponse.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 30/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

class ToxResponse<T : Codable> : Codable {
    var code : String = ""
    var responseObjects : T?
    var responseMessage : String?
    
    enum CodingKeys : String, CodingKey {
        case code = "code"
        case responseObjects = "response_objects"
        case responseMessage = "response_message"
    }
    
}

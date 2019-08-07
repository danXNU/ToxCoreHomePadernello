//
//  ToxRequestsHandler.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 01/08/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

struct ToxExecuteMessage: Codable {
    var objectID : Int
    var messageName : String
    
    enum CodingKeys: String, CodingKey {
        case objectID = "objID"
        case messageName = "messageName"
    }
}

struct ToxRemoveHandler : Codable {
    var objectID : Int
    var handlerID : Int
    
    enum CodingKeys : String, CodingKey {
        case objectID = "obj_id"
        case handlerID = "handlerID"
    }
}

struct ToxChangePropertiesValue : Codable {
    var objectID : Int
    var properties : [String : ToxArbitraryValueType]
    
    enum CodingKeys : String, CodingKey {
        case objectID = "obj_id"
        case properties = "properties"
    }
}

struct ToxAddExistingObjectsToAction : Codable {
    var actionID : Int
    var objectsIDs : [Int]
    
    enum CodingKeys : String, CodingKey {
        case actionID
        case objectsIDs = "objects_ids"
    }
}

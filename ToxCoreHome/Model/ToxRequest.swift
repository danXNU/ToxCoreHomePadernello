//
//  ToxRequest.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 29/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

enum ToxRequestEnum {
    case createObject
    case showObjects
    case showIDs
    case showIDsHandlers
    case addHandler
    case removeHandlers
    case executeMessage
    case showClasses
    case removeObject
    case changePropertiesValues
    case fetchHandlers
    case showActions
    case showActionObjects
    case removeObjectFromAction
    case addExistingObjectsToAction
    case showLiveObjects
}



class ToxRequest<T: Codable> : Codable {
    
    var requestType : String
    var requestBody : T
    
    var data : Data? {
        return try? JSONEncoder().encode(self)
    }
    
    enum CodingKeys: String, CodingKey {
        case requestType = "request-type"
        case requestBody = "request-body"
    }
    
    init(type: ToxRequestEnum, body: T) {
        self.requestBody = body
        
        switch type {
        case .createObject:
            requestType = "create_new_object"
        case .showObjects:
            requestType = "show_objects"
        case .showIDs:
            requestType = "show_ids"
        case .showIDsHandlers:
            requestType = "show_ids_h"
        case .addHandler:
            requestType = "add_handler"
        case .removeHandlers:
            requestType = "remove_handler"
        case .showClasses:
            requestType = "show_objects_classes"
        case .executeMessage:
            requestType = "execute_message"
        case .removeObject:
            requestType = "remove_object"
        case .changePropertiesValues:
            requestType = "change_properties_values"
        case .fetchHandlers:
            requestType = "get_handlers"
        case .showActions:
            requestType = "show_actions"
        case .showActionObjects:
            requestType = "show_objects_of_action"
        case .removeObjectFromAction:
            requestType = "remove_object_from_action"
        case .addExistingObjectsToAction:
            requestType = "add_some_existing_objects_to_action"
        case .showLiveObjects:
            requestType = "show_live_objects"
//        default:
//            requestType = "ping"
        }
    }
}

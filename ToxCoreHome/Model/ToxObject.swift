//
//  ToxObject.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 30/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

class ToxAction : ToxObject {
    
    var actionObjectsIDs : [Int] = []
    
    init(name: String, desc: String) {
        super.init(name: name, desc: desc, className: "ToxAction")
    }
    
    public func removeObjectFromMyList(_ object: ToxObject, completion: (Error?) -> Void) {
        guard let actionID = self.id else {
            completion(ToxError.inconsistencyLocalError(msg: "remvoeObjectFromList: action.id == NULL"))
            return
        }
        guard let objID = object.id else {
            completion(ToxError.inconsistencyLocalError(msg: "removeObjectFromList: object.id == NULL"))
            return
        }
        let body = ["action_id" : actionID, "obj_id" : objID]
        let request = ToxRequest(type: ToxRequestEnum.removeObjectFromAction, body: body)
        
        do {
            let server = try ToxSocket<[String : Int], String>()
            server.send(request: request) { (responseMsg, error) in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    public func addExistingObjectsToMyList(_ objects : [Int], completion: (Error?) -> Void) {
        guard let actionID = self.id else {
            completion(ToxError.inconsistencyLocalError(msg: "remvoeObjectFromList: action.id == NULL"))
            return
        }
        let body = ToxAddExistingObjectsToAction(actionID: actionID, objectsIDs: objects)
        let request = ToxRequest(type: ToxRequestEnum.addExistingObjectsToAction, body: body)
        do {
            let server = try ToxSocket<ToxAddExistingObjectsToAction, String>()
            server.send(request: request) { (returnMsg, error) in
                completion(error)
            }
        } catch {
            completion(error)
        }
        
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case actionObjectsIDs
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.actionObjectsIDs = try container.decode([Int].self, forKey: .actionObjectsIDs)
        try super.init(from: decoder)
    }
}

class ToxObject : Codable {
    var name : String
    var description : String
    var className : String
    var pin : Int?
    var customVariables : Dictionary<String, ToxValue> = [:]
    var handlers : [String : [ToxHandler]] = [:]
    var id : Int?
    var actionID : Int?
    var location : String?
    var messages : [String]?
    
    var isRepeatableObject : Bool?
    var liveProperty : String?
    
    var realLocation : String {
        let noLocationMsg = "non impostata"
//        guard let customVariables = self.customVariables else { return noLocationMsg }
        guard let location = customVariables["location"]?.value?.get() else { return noLocationMsg }
        guard let finalLocation = location as? String else { return noLocationMsg }
        if finalLocation.isEmpty { return noLocationMsg }
        return finalLocation
    }
    
    var isHandlersContainerEmpty : Bool {
        var count = 0
        for key in Array(self.handlers.keys) {
            count += (self.handlers[key]?.count ?? 0)
        }
        return (count == 0) ? true : false
    }
    
    init(name: String, desc: String, className : String) {
        self.name = name
        self.description = desc
        self.className = className
    }
    
    public func execute(message: String, completionHandler: (Error?) -> Void) {
        guard let id = self.id, let messages = self.messages else {
            completionHandler(ToxError.inconsistencyLocalError(msg: "ID e/o Messages == nil"))
            return
        }
        if !messages.contains(message) {
            completionHandler(ToxError.inconsistencyLocalError(msg: "Il messaggio passato non è contenuto nei messaggi di questo oggetto"))
            return
        }
        print("executeMessage: \(id).\(message)")

        let body = ToxExecuteMessage(objectID: id, messageName: message)
        let request = ToxRequest(type: ToxRequestEnum.executeMessage, body: body)
        do {
            let server = try ToxSocket<ToxExecuteMessage, String>()
            server.send(request: request) { (returnMsg, error) in
                completionHandler(error)
            }
        } catch {
            completionHandler(error)
        }

    }
    
    
    public func remove(handler: Int, completion: (Error?) -> Void) {
        guard let objectID = self.id else {
            completion(ToxError.inconsistencyLocalError(msg: "ID oggetto == NULL"))
            return
        }
        let handlerID = handler

        let body = ToxRemoveHandler(objectID: objectID, handlerID: handlerID)
        let request = ToxRequest(type: ToxRequestEnum.removeHandlers, body: body)
    
        do {
            let server = try ToxSocket<ToxRemoveHandler, String>()
            server.send(request: request) { (returnMsg, error) in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    public func fetchHandlers(completion: (Error?) -> Void) {
        guard let myID = self.id else {
            completion(ToxError.inconsistencyLocalError(msg: "Oggettoselezionato.id == nil"))
            return
        }
        let body = ["obj_id" : myID]
        let request = ToxRequest(type: ToxRequestEnum.fetchHandlers, body: body)
        do {
            let server = try ToxSocket<[String:Int], [String: [ToxHandler]]>()
            server.send(request: request) { (optionalHandlers, serverError) in
                if serverError != nil {
                    completion(serverError!)
                    return
                }
                
                guard let handlers = optionalHandlers else {
                    completion(ToxError.invalidResponseMessage(msg: "handlers ricevuti == nil"))
                    return
                }
                
                self.handlers = handlers
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
    
    public func addHandlerOnServer(_ handler: ToxHandler, completion : (Error?) -> Void) {
        let request = ToxRequest(type: ToxRequestEnum.addHandler, body: handler)

        do {
            let server = try ToxSocket<ToxHandler, String>()
            server.send(request: request) { (returnMsg, error) in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    public func addMeOnServer(completion: (Error?) -> Void) {
        let request = ToxRequest(type: ToxRequestEnum.createObject, body: self)

        do {
            let server = try ToxSocket<ToxObject, String>()
            server.send(request: request) { (returnMsg, error) in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    public func change(properties : [String : Codable], completion: (Error?) -> Void) {
        guard let id = self.id else {
            completion(ToxError.inconsistencyLocalError(msg: "Quetso oggetto non ha un ID"))
            return
        }
        guard let typedProperties = properties as? [String : ToxArbitraryValueType] else {
            completion(ToxError.inconsistencyLocalError(msg: "Non sono riuscito ad ottenere delle properties del tipo giusto. Ho bisogno di [String : ToxArbitraryValueType]"))
            return
        }
        let requestStruct = ToxChangePropertiesValue(objectID: id, properties: typedProperties)

        let request = ToxRequest(type: ToxRequestEnum.changePropertiesValues, body: requestStruct)

        do {
            let server = try ToxSocket<ToxChangePropertiesValue, String>()
            server.send(request: request) { (returnMsg, error) in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
}

//enum ObjectsType : String {
//    case object = "Object"
//    case digitalOutDevice = "DigitalOutputDevice"
//    case timer = "Timer"
//}


class ToxHandler : Codable {
    var id : Int = 0
    var args: [String]?
    var key: String?
    var function : ToxFunction
    var idObjectOwner : Int?
    
    init(funct: ToxFunction) {
        self.function = funct
    }
    
    enum CodingKeys : String, CodingKey {
        case id
        case args
        case key
        case function
        case idObjectOwner = "id_object_owner"
    }
}

class ToxFunction : Codable {
    var functionName : String = ""
    var objectID : Int = 0
    var objectName : String? {
        for object in ToxContainer.shared.allTypesOfObjects {
            if object.id == objectID {
                return object.name
            }
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey
    {
        case functionName
        case objectID = "objectId"
    }
}

class ToxValue : Codable, CustomStringConvertible {
    var description: String {
        if let currValue = self.value?.get() as? String {
            return "[valueType : \(valueType), value : \(currValue)]"
        } else if let currValue = self.value?.get() as? Int {
            return "[valueType : \(valueType), value : \(currValue)]"
        } else if let currValue = self.value?.get() as? Float {
            return "[valueType : \(valueType), value : \(currValue)]"
        } else {
            return "[valueType : \(valueType), value : ErrorValue]"
        }
        
    }
    
    var valueType : String
    var value : ToxArbitraryValueType?
    
    init(type : String, value: ToxArbitraryValueType) {
        self.valueType = type
        self.value = value
    }
}

class ToxObjectProperty : Codable {
    var propertyName : String
    var value : ToxValue
    
    init(propertyName : String, value: ToxValue) {
        self.propertyName = propertyName
        self.value = value
    }
}


enum ToxArbitraryValueType : Codable, Equatable {
    case int(Int)
    case string(String)
    case float(Float)
    case list([ToxArbitraryValueType])
    case dictionary([String : ToxArbitraryValueType])
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .int(try container.decode(Int.self))
        } catch DecodingError.typeMismatch {
            do {
                self = .float(try container.decode(Float.self))
            } catch {
                do {
                    self = .string(try container.decode(String.self))
                } catch DecodingError.typeMismatch {
                    do {
                        self = .list(try container.decode([ToxArbitraryValueType].self))
                    } catch DecodingError.typeMismatch {
                        self = .dictionary(try container.decode([String : ToxArbitraryValueType].self))
                    }
                }
            }
            
        }
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let int): try container.encode(int)
        case .float(let float): try container.encode(float)
        case .string(let string): try container.encode(string)
        case .list(let list): try container.encode(list)
        case .dictionary(let dictionary): try container.encode(dictionary)
        }
    }
    
    func get() -> Any {
        switch self {
        case .int(let num):
            return num
        case .float(let numF):
            return numF
        case .string(let str):
            return str
        case .dictionary(let dict):
            return dict
        case .list(let list):
            return list
        }
    }
    
    
    static func ==(_ lhs: ToxArbitraryValueType, _ rhs : ToxArbitraryValueType) -> Bool {
        switch (lhs, rhs) {
        case (.int(let int1), .int(let int2)): return int1 == int2
        case (.string(let string1), .string(let string2)): return string1 == string2
        case (.list(let list1), .list(let list2)): return list1 == list2
        case (.dictionary(let dict1), .dictionary(let dict2)): return dict1 == dict2
        default: return false
        }
    }
}

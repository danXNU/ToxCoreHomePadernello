//
//  ToxContainer.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 31/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

class ToxContainer {

    static let shared = ToxContainer()
    private init() {}
    
    var allObjects : [ToxObject] = [] {
        didSet {
            allAvailableObjectsContainer.removeAll()
        }
    }
    var allActions : [ToxAction] = [] {
        didSet {
            allAvailableObjectsContainer.removeAll()
        }
    }
    var allClasses : [String] = []
    
    private var allAvailableObjectsContainer : [ToxObject] = []
    
    var allTypesOfObjects : [ToxObject] {
        if self.allAvailableObjectsContainer.isEmpty {
            var tempArray = [ToxObject]()
            tempArray.append(contentsOf: self.allObjects)
            tempArray.append(contentsOf: self.allActions)
            allAvailableObjectsContainer = []
            allAvailableObjectsContainer = tempArray
            return tempArray
        } else {
            return allAvailableObjectsContainer
        }
    }
    
    var selectedObject : ToxObject?
    
    public func fetchObjectsFrom(list : [Int]) -> [ToxObject] {
        var array : [ToxObject] = []
        for id in list {
            if let object = self.allObjects.get(by: id) {
                array.append(object)
            }
        }
        return array
    }
    
    public func fetchObjectsOfAction(action: ToxAction, completion: (Error?, [ToxObject]?) -> Void) {
        guard let actionID = action.id else {
            completion(ToxError.inconsistencyLocalError(msg: "action.id == NULL"), nil)
            return
        }
        let body = ["action_id" : actionID]
        let request = ToxRequest(type: ToxRequestEnum.showActionObjects, body: body)
        do {
            let server = try ToxSocket<[String: Int], [ToxObject]>()
            server.send(request: request) { (optionalObjects, error) in
                if error != nil {
                    completion(error!, nil)
                    return
                }
                
                guard let unwrappedObjects = optionalObjects else {
                    completion(ToxError.invalidResponseMessage(msg: "Oggetti ottenuti == NULL"), nil)
                    return
                }
                
                completion(nil, unwrappedObjects)
            }
        } catch {
            completion(error, nil)
        }
    }
    
    private func set(classes: [String]) {
        self.allClasses.removeAll()
        self.allClasses.append(contentsOf: classes)
    }

    private func set(objects: [ToxObject]) {
        self.allObjects.removeAll()
        self.allObjects.append(contentsOf: objects)
    }
    
    public func set(actions: [ToxAction]) {
        self.allActions.removeAll()
        self.allActions.append(contentsOf: actions)
    }
    
    public func fecthObjectsNow() {
        self.fetchObjects { (error) in
            if error != nil {
                print(error!)
            } else {
                self.fecthActions(compeltionFetch: { (error) in
                    if error != nil {
                        print(error!)
                    }
                })
            }
        }
    }
    
    public func fetchObjects(completionFetch: (Error?) -> Void) {
        
        do {
            let server = try ToxSocket<String, [ToxObject]>()
            let request = ToxRequest(type: ToxRequestEnum.showObjects, body: "")
            server.send(request: request) { (optionalObjects, serverError) in
                
                if serverError != nil {
                    completionFetch(serverError!)
                    return
                }
                
                guard let objects = optionalObjects else {
                    completionFetch(ToxError.invalidResponseMessage(msg: "Oggetti ottenuti == nil"))
                    return
                }
                
                self.set(objects: objects.reversed())
                completionFetch(nil)
                
            }
            
        } catch {
            completionFetch(error)
        }
        
        
    }
    
    public func fetchClasses(completionFetch : (Error?) -> Void) {
        do {
            let server = try ToxSocket<String, [String]>()
            let request = ToxRequest(type: ToxRequestEnum.showClasses, body: "")
            server.send(request: request) { (optionalClasses, serverError) in
                if serverError != nil {
                    completionFetch(serverError!)
                    return
                }
                guard let classes = optionalClasses else {
                    completionFetch(ToxError.invalidResponseMessage(msg: "classes == nil"))
                    return
                }
                
                self.set(classes: classes)
                completionFetch(nil)
                
            }
            
        } catch {
            completionFetch(error)
        }
    }
    
    public func fecthActions(compeltionFetch : (Error?) -> Void) {
        do {
            let server = try ToxSocket<String, [ToxAction]>()
            let request = ToxRequest(type: ToxRequestEnum.showActions, body: "")
            server.send(request: request) { (optionalActions, serverError) in
                if serverError != nil {
                    compeltionFetch(serverError!)
                    return
                }
                guard let actions = optionalActions else {
                    compeltionFetch(ToxError.invalidResponseMessage(msg: "actions == nil"))
                    return
                }
                
                self.set(actions: actions)
                compeltionFetch(nil)
            }
        } catch {
            compeltionFetch(error)
        }
    }
    
    public func fetchLiveObjects(completion: ([ToxObject]?, Error?) -> Void) {
        let request = ToxRequest(type: ToxRequestEnum.showLiveObjects, body: "")
        do {
            let server = try ToxSocket<String, [ToxObject]>()
            server.send(request: request) { (optionalObjects, error) in
                if error != nil {
                    completion(nil, error)
                    return
                }
                if let liveObjects = optionalObjects {
                    completion(liveObjects, nil)
                } else {
                    completion(nil, ToxError.invalidResponseMessage(msg: "liveObjects == NULL"))
                }
            }
        } catch {
            completion(nil, error)
        }
    }
    
}

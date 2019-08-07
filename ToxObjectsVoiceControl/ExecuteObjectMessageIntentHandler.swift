//
//  ExecuteObjectMessageIntentHandler.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 22/08/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

class ExecuteObjectMessageIntentHandler : NSObject, ExecuteObjectMessageIntentHandling {
    
    
    func confirm(intent: ExecuteObjectMessageIntent, completion: @escaping (ExecuteObjectMessageIntentResponse) -> Void) {
        guard let _ = intent.message else {
            completion(ExecuteObjectMessageIntentResponse(code: .failure, userActivity: nil))
            return
        }
        guard let _ = intent.objectID as? Int else {
            completion(ExecuteObjectMessageIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        ToxContainer.shared.fecthObjectsNow()
        completion(ExecuteObjectMessageIntentResponse(code: .ready, userActivity: nil))
        
    }
    
    func handle(intent: ExecuteObjectMessageIntent, completion: @escaping (ExecuteObjectMessageIntentResponse) -> Void) {
        
        guard let object = ToxContainer.shared.allTypesOfObjects.get(by: intent.objectID as! Int) else {
            completion(ExecuteObjectMessageIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        let message = intent.message!
        object.execute(message: message) { (error) in
            if error != nil {
                completion(ExecuteObjectMessageIntentResponse(code: .failure, userActivity: nil))
            } else {
                completion(ExecuteObjectMessageIntentResponse(code: .success, userActivity: nil))
            }
        }
        
    
        
    }
    
    
}

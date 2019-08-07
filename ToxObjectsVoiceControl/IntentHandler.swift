//
//  IntentHandler.swift
//  ToxObjectsVoiceControl
//
//  Created by Dani Tox on 22/08/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        guard intent is ExecuteObjectMessageIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        
        return ExecuteObjectMessageIntentHandler()
    }
    
}

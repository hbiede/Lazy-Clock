//
//  IntentHandler.swift
//  LazyIntent
//
//  Created by Hundter Biede on 8/27/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.

        guard intent is LazyClockIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        
        return LazyClockIntentHandler()
    }
}

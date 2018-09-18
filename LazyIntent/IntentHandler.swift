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
        if intent is LazyClockIntent {
            return LazyClockIntentHandler()
        } else if intent is LazyClockSpecifiedIntent {
            return LazyClockSpecifiedIntentHandler()
        } else {
            fatalError("Unhandled intent type: \(intent)")
        }
    }
}

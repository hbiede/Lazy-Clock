//
//  LazyClockIntentHandler.swift
//  LazyIntent
//
//  Created by Hundter Biede on 8/27/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import Foundation

class LazyClockIntentHandler: NSObject, LazyClockIntentHandling {

    /// DateFormatter to be used to update the time.
    let dForm: DateFormatter = {
        let temp = DateFormatter()
        temp.dateFormat = "HH:mm"
        return temp
    }()

    func handle(intent: LazyClockIntent, completion: @escaping (LazyClockIntentResponse) -> Void) {
        var natTime = NaturalLanguageTime.NatTime()
        /*
        //Set timeString to inputTime if it is a parameter that exists for intent, else set it to the current time
        let inputTime = intent.inputTime == nil ? dForm.string(from: Date()) : intent.inputTime!
        natTime.timeString = inputTime
         */
        natTime.timeString = dForm.string(from: Date())
        completion(LazyClockIntentResponse.success(timeResponse: natTime.getNatLangString()))
    }

}

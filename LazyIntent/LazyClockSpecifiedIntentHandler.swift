//
//  LazyClockSpecifiedHandler.swift
//  LazyIntent
//
//  Created by Hundter Biede on 9/18/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import Foundation
import UIKit

class LazyClockSpecifiedIntentHandler: NSObject, LazyClockSpecifiedIntentHandling {
    func handle(intent: LazyClockSpecifiedIntent, completion: @escaping (LazyClockSpecifiedIntentResponse) -> Void) {
        /*
         //Set timeString to inputTime if it is a parameter that exists for intent, else set it to the current time
         let inputTime = intent.inputTime == nil ? dForm.string(from: Date()) : intent.inputTime!
         natTime.timeString = inputTime
         */

        let pasteboardString = UIPasteboard.general.string
        guard let pasteboardContents = pasteboardString else {
            completion(LazyClockSpecifiedIntentResponse.failure(timeInput: "nil"))
            return
        }

        if validTimeCode(input: pasteboardContents) {
            var natTime = NaturalLanguageTime.NatTime()
            natTime.timeString = pasteboardContents
            UIPasteboard.general.string = natTime.getNatLangString()
            completion(LazyClockSpecifiedIntentResponse.success(timeResponse: natTime.getNatLangString()))
        } else {
            completion(LazyClockSpecifiedIntentResponse.failure(timeInput: pasteboardContents))
        }

    }

    func validTimeCode(input: String) -> Bool {
        let regexPattern = "^[0-9]{1,2}:[0-5][0-9]$"
        var matches: [NSTextCheckingResult]
        if let regex = try? NSRegularExpression(pattern: regexPattern) {
            matches = regex.matches(in: input, options:[], range: NSRange(location: 0, length: input.count))
            if matches[0].range != NSRange(location: 0, length: input.count) {
                return false
            }
        }

        let tempArray = input.split(separator: ":")
        if  Int(tempArray[0])! < 0 || Int(tempArray[0])! >= 24 {
            return false
        }
        if  Int(tempArray[1])! < 0 || Int(tempArray[1])! >= 60 {
            return false
        }

        return true
    }
}

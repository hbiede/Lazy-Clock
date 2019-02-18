//
//  NaturalLanguageTime.swift
//  Natural Language Time
//
//  Created by Hundter Biede on 7/26/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import Foundation

open class NaturalLanguageTime {

    /// Creates a new NatTime object to be used to convert a time to a natural langauge output.
    ///
    /// Takes an input of the form 'hh:mm' or 'hh:mm:ss' to create a natural language version of the time, ie an input of "16:30"
    /// would yield "half past 4"
    public struct NatTime {
        private var hours:Int?, minutes:Int?
        private var natLangString:String! = "Default Time"
        public var timeString: String! {
            get {
                return (hours == nil || minutes == nil) ? "Default Time" : "\(String(describing: hours!))-\(String(describing: minutes!))"
            }
            set {
                let tempArray = newValue.split(separator: ":")
                hours = Int(tempArray[0]) ?? nil
                // Change 24 to 12 hour time
                if (DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!.contains("a") && hours! > 12) {
                    hours = hours! - 12
                }
                if tempArray.count > 1 {
                    minutes = Int(tempArray[1]) ?? nil
                } else {
                    minutes = nil
                }
                if hours != nil && minutes != nil {
                    natLangString = toNatLang()
                } else {
                    natLangString = "Default Time"
                }
            }
        }

        public init(){}
        
        public func getNatLangString() -> String! {
            return natLangString
        }

        func roundByFive(_ inputNumber: Int!) -> Int {
            return Int(ceil(Double(inputNumber) / 5)) * 5
        }

        public func toNatLang() -> String {
            guard var minuteValue = minutes else {
                return "Default Time"
            }
            var hourAsString = NSLocalizedString(String(describing: hours!), comment:
                "The current hour, spelled out")
            let oneOClock = hours! == 1 || (hours! == 13 && !DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!.contains("a"))
            let midnightAsString = NSLocalizedString("0", comment: "midnight")
            let nextHourAsString = NSLocalizedString(String(describing: hours! + 1), comment: "The next hour, spelled out")
            minuteValue = roundByFive(minuteValue)
            var returnStatementFormat:String
            
            switch minuteValue {
            case 0, 60:
                if (minuteValue == 60) {
                    hourAsString = (hours! == 23 ? midnightAsString : nextHourAsString)
                }
                if (hours! == 23 || hours! == 11 || hours! == 0 || hours! == 12)
                {
                    return hourAsString
                } else {
                    returnStatementFormat = NSLocalizedString(oneOClock ? "%@ o'clock-one" : "%@ o'clock", comment: "Time on the hour")
                }
            case 5:
                returnStatementFormat = NSLocalizedString(oneOClock ? "Five past %@-one" : "Five past %@", comment: "Five past the hour")
            case 15:
                returnStatementFormat = NSLocalizedString(oneOClock ? "Quarter past %@-one" : "Quarter past %@", comment: "Quarter past the hour")
            case 30:
                returnStatementFormat = NSLocalizedString(oneOClock ? "Half past %@-one" : "Half past %@", comment: "Half past the hour")
            case 45:
                hourAsString = (hours! == 23 ? midnightAsString : nextHourAsString)
                returnStatementFormat = NSLocalizedString(oneOClock ? "Quarter til %@-one" : "Five past %@", comment: "Quarter til the hour")
            case 50:
                hourAsString = (hours! == 23 ? midnightAsString : nextHourAsString)
                returnStatementFormat = NSLocalizedString(oneOClock ? "Ten til %@-one" : "Ten til %@", comment: "Ten til the hour")
            case 55:
                hourAsString = (hours! == 23 ? midnightAsString : nextHourAsString)
                returnStatementFormat = NSLocalizedString(oneOClock ? "Five til %@-one" : "Five til %@", comment: "Five til the hour")
            default:
                returnStatementFormat = NSLocalizedString(oneOClock ? "%@ %@-one" : "%@ %@", comment: "Default")
                print(returnStatementFormat)
                let minuteAsString = NSLocalizedString(String(describing: minuteValue), comment: "Minute Value")
                return String.localizedStringWithFormat(returnStatementFormat, hourAsString, minuteAsString)
            }
            
            return String.localizedStringWithFormat(returnStatementFormat, hourAsString)
        }
    }
}

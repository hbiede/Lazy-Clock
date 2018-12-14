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
        private let hourConversion = [0: "Midnight", 1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine", 10: "Ten", 11: "Eleven", 12: "Noon", 13: "One", 14: "Two", 15: "Three", 16: "Four", 17: "Five", 18: "Six", 19: "Seven", 20: "Eight", 21: "Nine", 22: "Ten", 23: "Eleven"]
        private let minuteConversion = [10: "Ten", 20: "Twenty", 25: "Twenty Five", 35: "Thirty Five", 40: "Forty"]
        private var hours:Int?, minutes:Int?
        private var natLangString:String! = "Default Time"
        public var timeString: String! {
            get {
                return (hours == nil || minutes == nil) ? "Default Time" : "\(String(describing: hours!))-\(String(describing: minutes!))"
            }
            set {
                let tempArray = newValue.split(separator: ":")
                hours = Int(tempArray[0]) ?? nil
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

        func toNatLang() -> String {
            guard var hourString = hourConversion[hours!] else { return "Default Time" }
            guard var minuteValue = minutes else { return "Default Time" }
            minuteValue = roundByFive(minuteValue)
            var returnStatement:String

            switch minuteValue {
            case 0, 60:
                if (minuteValue == 60) {
                    hourString = (hours! == 23 ? hourConversion[0] : hourConversion[hours! + 1])!
                }
                if (hours! == 23 || hours! == 11 || hours! == 0 || hours! == 12)
                {
                    returnStatement = "\(hourString)"
                } else {
                    returnStatement = "\(hourString) o'clock"
                }
            case 5:
                returnStatement = "Five past \(hourString)"
            case 15:
                returnStatement = "Quarter past \(hourString)"
            case 30:
                returnStatement = "Half past \(hourString)"
            case 45:
                hourString = (hours! == 23 ? hourConversion[0] : hourConversion[hours! + 1])!
                returnStatement = "Quarter til \(hourString)"
            case 50:
                hourString = (hours! == 23 ? hourConversion[0] : hourConversion[hours! + 1])!
                returnStatement = "Ten til \(hourString)"
            case 55:
                hourString = (hours! == 23 ? hourConversion[0] : hourConversion[hours! + 1])!
                returnStatement = "Five til \(hourString)"
            default:
                returnStatement = (hours! == 12 || hours! == 0) ? "Twelve \(minuteConversion[minuteValue] ?? "")" : "\(hourString) \(minuteConversion[minuteValue] ?? "")"
            }

            return returnStatement.capitalized
        }
    }
}

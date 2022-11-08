//
//  NaturalLanguageTime.swift
//  Natural Language Time
//
//  Created by Hundter Biede on 7/26/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import Foundation

/// Creates a new NatTime object to be used to convert a time to a natural langauge output.
///
/// Takes an input of the form 'hh:mm' or 'hh:mm:ss' to create a natural language version of the time,
/// ie an input of "16:30" would yield "half past 4"
public struct NaturalLanguageTime: CustomStringConvertible {
    private var hours: Int?, minutes: Int?

    var _description: String = "Default Time"
    public var description: String {
        return _description
    }

    public var timeString: String! {
        get {
            return (hours == nil || minutes == nil)
                ? "Default Time"
                : "\(String(describing: hours!))-\(String(describing: minutes!))"
        }
        set {
            let tempArray = newValue.split(separator: ":")
            hours = Int(tempArray[0]) ?? nil
            minutes = Int(tempArray[1]) ?? 0
            _description = hours == nil ? "Default Time" : toNatLang()
        }
    }

    public init() {
        self.init(Date())
    }

    public init(_ date: Date) {
        let formatter: DateFormatter = {
            let temp = DateFormatter()
            temp.dateFormat = "HH:mm:ss"
            return temp
        }()
        timeString = formatter.string(from: date)
    }

    public init(_ time: String) {
        timeString = time
    }

    func roundByFive(_ inputNumber: Int!) -> Int {
        return Int(ceil(Double(inputNumber) / 5)) * 5
    }

    public func toNatLang() -> String {
        guard var minuteValue = minutes else {
            return "Default Time"
        }
        let is12HourClock = NSLocale.current.hourCycle == .oneToTwelve
        let hoursValue = hours! > 12 && is12HourClock
                ? hours! - 12
                : hours!
        let nextHour = (hoursValue == 12 && is12HourClock) || (hoursValue == 0 && !is12HourClock) ? 1 : (hoursValue + 1)
        let oneOClock = hoursValue == 1 ||
          (hoursValue == 13 &&
           !DateFormatter.dateFormat(
                fromTemplate: "j",
                options: 0,
                locale: Locale.current
           )!.contains("a"))
        let nextHourAsString = hours == 23
                ? NSLocalizedString("0", comment: "midnight")
                : NSLocalizedString(
                    String(describing: nextHour),
                    comment: "The next hour, spelled out"
                  )
        minuteValue = roundByFive(minuteValue)
        var hourAsString = minuteValue >= 45
            ? nextHourAsString
            : NSLocalizedString(
                String(describing: hoursValue),
                comment: "The current hour, spelled out"
              )

        if NSLocale.current.identifier == "en_GB" && minuteValue == 30 {
            hourAsString = NSLocalizedString(
                String(describing: hoursValue + 1),
                comment: "The current hour, spelled out, but incremented for british time telling"
            )
        }

        if (minuteValue == 0 || minuteValue == 60) &&
            (hoursValue == 23 || hoursValue == 11 || hoursValue == 0 || hoursValue == 12) {
            return hourAsString
        }

        if let format = getFormatString(minuteValue, oneOClock) {
            // Specialty return
            return String.localizedStringWithFormat(format, hourAsString)
        }

        // Default
        let returnStatementFormat = NSLocalizedString(
            oneOClock ? "%@ %@-one" : "%@ %@",
            comment: "Default"
        )
        let minuteAsString = NSLocalizedString(
            String(describing: minuteValue),
            comment: "Minute Value"
        )

        hourAsString = hoursValue == 0 || hoursValue == 12
            ? NSLocalizedString(
                "12-standard",
                comment: "minuteValue"
              )
            : hourAsString
        return String.localizedStringWithFormat(
            returnStatementFormat,
            hourAsString,
            minuteAsString
        )
    }

    func getFormatString(_ minuteValue: Int, _ oneOClock: Bool = false) -> String? {
        switch minuteValue {
        case 0, 60:
            return NSLocalizedString(
                oneOClock ? "%@ o'clock-one" : "%@ o'clock",
                comment: "Time on the hour"
            )
        case 5:
            return NSLocalizedString(
                oneOClock ? "Five past %@-one" : "Five past %@",
                comment: "Five past the hour"
            )
        case 10:
            return NSLocalizedString(
                oneOClock ? "Ten past %@-one" : "Ten past %@",
                comment: "Ten past the hour"
            )
        case 15:
            return NSLocalizedString(
                oneOClock ? "Quarter past %@-one" : "Quarter past %@",
                comment: "Quarter past the hour"
            )
        case 30:
            return NSLocalizedString(
                oneOClock ? "Half past %@-one" : "Half past %@",
                comment: "Half past the hour"
            )
        case 45:
            return NSLocalizedString(
                oneOClock
                    ? "Quarter til %@-one"
                    : "Quarter til %@",
                comment: "Quarter til the hour"
            )
        case 50:
            return NSLocalizedString(
                oneOClock ? "Ten til %@-one" : "Ten til %@",
                comment: "Ten til the hour"
            )
        case 55:
            return NSLocalizedString(
                oneOClock ? "Five til %@-one" : "Five til %@",
                comment: "Five til the hour"
            )
        default:
            return nil
        }
    }
}

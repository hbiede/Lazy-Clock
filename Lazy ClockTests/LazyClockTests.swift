//
//  Lazy_ClockTests.swift
//  Lazy ClockTests
//
//  Created by Hundter Biede on 12/14/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import XCTest

class LazyClockTests: XCTestCase {
    func testTimeConversion() {
        var natTime = NaturalLanguageTime()

        natTime.timeString = "00:00"
        XCTAssertEqual(natTime.description, "Midnight")

        natTime.timeString = "00:05"
        XCTAssertEqual(natTime.description, "Five past Midnight")

        natTime.timeString = "00:08"
        XCTAssertEqual(natTime.description, "Ten past Midnight")

        natTime.timeString = "00:10"
        XCTAssertEqual(natTime.description, "Ten past Midnight")

        natTime.timeString = "00:15"
        XCTAssertEqual(natTime.description, "Quarter past Midnight")

        natTime.timeString = "00:20"
        XCTAssertEqual(natTime.description, "Twelve Twenty")

        natTime.timeString = "00:25"
        XCTAssertEqual(natTime.description, "Twelve Twenty-Five")

        natTime.timeString = "00:30"
        XCTAssertEqual(natTime.description, "Half past Midnight")

        natTime.timeString = "00:35"
        XCTAssertEqual(natTime.description, "Twelve Thirty-Five")

        natTime.timeString = "00:45"
        XCTAssertEqual(natTime.description, "Quarter til One")

        natTime.timeString = "00:50"
        XCTAssertEqual(natTime.description, "Ten til One")

        natTime.timeString = "00:55"
        XCTAssertEqual(natTime.description, "Five til One")

        natTime.timeString = "01:30"
        XCTAssertEqual(natTime.description, "Half past One")

        natTime.timeString = "01:55"
        XCTAssertEqual(natTime.description, "Five til Two")

        natTime.timeString = "12:00"
        XCTAssertEqual(natTime.description, "Noon")

        natTime.timeString = "12:20"
        XCTAssertEqual(natTime.description, "Twelve Twenty")

        natTime.timeString = "12:55"
        XCTAssertEqual(natTime.description, "Five til One")

        natTime.timeString = "13:53"
        XCTAssertEqual(natTime.description, "Five til Two")

        natTime.timeString = "13:55"
        XCTAssertEqual(natTime.description, "Five til Two")

        natTime.timeString = "14:20"
        XCTAssertEqual(natTime.description, "Two Twenty")

        natTime.timeString = "14:30"
        XCTAssertEqual(natTime.description, "Half past Two")
        
        natTime.timeString = "14:45"
        XCTAssertEqual(natTime.description, "Quarter til Three")
        
        natTime.timeString = "15:10"
        XCTAssertEqual(natTime.description, "Ten past Three")

        natTime.timeString = "23:13"
        XCTAssertEqual(natTime.description, "Quarter past Eleven")

        natTime.timeString = "23:55"
        XCTAssertEqual(natTime.description, "Five til Midnight")
    }
}

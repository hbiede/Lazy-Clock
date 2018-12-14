//
//  Lazy_ClockTests.swift
//  Lazy ClockTests
//
//  Created by Hundter Biede on 12/14/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import XCTest

class Lazy_ClockTests: XCTestCase {

    func timeConversionTest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var natTime = NaturalLanguageTime.NatTime()

        natTime.timeString = "00:00"
        XCTAssert(natTime.getNatLangString() == "Midnight")

        natTime.timeString = "00:05"
        XCTAssert(natTime.getNatLangString() == "Five Past Midnight")

        natTime.timeString = "00:10"
        XCTAssert(natTime.getNatLangString() == "Ten Past Midnight")

        natTime.timeString = "00:15"
        XCTAssert(natTime.getNatLangString() == "Quarter Past Midnight")

        natTime.timeString = "00:20"
        XCTAssert(natTime.getNatLangString() == "Twelve Twenty")

        natTime.timeString = "00:25"
        XCTAssert(natTime.getNatLangString() == "Twelve Twenty Five")

        natTime.timeString = "00:30"
        XCTAssert(natTime.getNatLangString() == "Half Past Midnight")

        natTime.timeString = "00:35"
        XCTAssert(natTime.getNatLangString() == "Twelve Thirty Five")

        natTime.timeString = "00:45"
        XCTAssert(natTime.getNatLangString() == "Quarter Til One")

        natTime.timeString = "00:50"
        XCTAssert(natTime.getNatLangString() == "Ten Til One")

        natTime.timeString = "00:55"
        XCTAssert(natTime.getNatLangString() == "Five Til One")

    }

}

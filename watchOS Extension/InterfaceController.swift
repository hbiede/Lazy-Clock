//
//  InterfaceController.swift
//  watchOS Extension
//
//  Created by Hundter Biede on 12/14/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var timeLbl: WKInterfaceLabel!

    /// DateFormatter to be used to update the time, either to the form of short or long form time.
    let formatter: DateFormatter = {
        let temp = DateFormatter()
        temp.dateFormat = "HH:mm:ss"
        return temp
    }()

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        updateTime()
        super.willActivate()
    }

    override func didAppear() {
        super.didAppear()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    /// Updates time displayed on display. Runs once on watchOS (Working under the assumption that the watch face will not be shown for an extended period of time
    func updateTime() {
        var natTime = NaturalLanguageTime.NatTime()
        natTime.timeString = formatter.string(from: Date())
        timeLbl.setText(natTime.toNatLang())
    }
}

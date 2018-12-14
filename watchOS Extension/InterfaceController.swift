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
    let dForm: DateFormatter = {
        let temp = DateFormatter()
        temp.dateFormat = "HH:mm:ss"
        return temp
    }()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        updateTime()
    }

    override func didAppear() {
        super.didAppear()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    /// Updates time displayed on display. Called from Timer in viewDidLoad().
    @objc
    func updateTime() {
        var natTime = NaturalLanguageTime.NatTime()
        natTime.timeString = dForm.string(from: Date())
        timeLbl.setText(natTime.getNatLangString())
    }
}

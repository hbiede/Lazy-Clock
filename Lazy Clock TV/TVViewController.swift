//
//  ViewController.swift
//  Lazy Clock TV
//
//  Created by Hundter Biede on 8/1/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import UIKit

class TVViewController: UIViewController {

    // UIView Object Outlets
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet var viewBG: UIView!

    /// DateFormatter to be used to update the time, either to the form of short or long form time.
    let dForm: DateFormatter = {
        let temp = DateFormatter()
        temp.dateFormat = "hh-mm"
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print("Lazy Clock Launched Successfully")

        // Starts the clock on updating every second
        updateTime()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    /// Updates time displayed on display. Called from Timer in viewDidLoad().
    @objc func updateTime() {
        var natTime = NaturalLanguageTime.NatTime()
        natTime.timeString = dForm.string(from: Date())
        timeLbl.text = natTime.getNatLangString()
    }
}


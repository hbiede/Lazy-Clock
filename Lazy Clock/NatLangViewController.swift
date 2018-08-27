//
//  NatLangViewController.swift
//  Lazy Clock
//
//  Created by Hundter Biede on 8/26/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import Foundation
import UIKit

class NatLangViewController: UIViewController {
    /// IBOutlets
    @IBOutlet var viewBG: UIView!
    @IBOutlet var timeLbl: UILabel!

    /// Dictionary of the UIColors to be used in the rotation of the clock display.
    let colorRotation = [UIColor.white, UIColor.red, UIColor.blue, UIColor.green, UIColor.black]

    /// ImpactFeedbackGenerator to be used to create haptic feedback.
    #if os(iOS)
    let impactor = UIImpactFeedbackGenerator.init()
    #endif

    /// UserDefaults used to store settings for the app.
    let userSettings = UserDefaults.standard

    /// DateFormatter to be used to update the time, either to the form of short or long form time.
    let dForm: DateFormatter = {
        let temp = DateFormatter()
        temp.dateFormat = "hh-mm"
        return temp
    }()

    /// Index to use to cycle through colorRotation[] for the updating of the clock textColor. Defaults to 0.
    var colorRotationIndex:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        #if os(iOS)
        // Loads saved data for the color of the clock
        colorRotationIndex = userSettings.integer(forKey: "LazyClock-ColorIndex")
        updateColor(colorRotation[colorRotationIndex])
        #endif

        // Sets defaults for the timeLbl
        timeLbl.adjustsFontSizeToFitWidth = true
        timeLbl.adjustsFontForContentSizeCategory = true
        print("Lazy Clock Launched Successfully")

        // Starts the clock on updating every second
        updateTime()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }

    func viewSet(label: UILabel!, bg: UIView!) {
        timeLbl = label
        viewBG = bg
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

    #if os(iOS)
    /// Updates the color of timeLbl.textColor.
    ///
    /// - Parameters:
    ///   - newColor: A UIColor to change timeLbl.textColor to.
    func updateColor(_ newColor: UIColor!) {
        timeLbl.textColor = newColor
        if (timeLbl.textColor == UIColor.black) {
            viewBG.backgroundColor = UIColor.white
        } else {
            viewBG.backgroundColor = UIColor.black
        }
    }

    @IBAction func onTouch(_ sender: Any) {
        touchRecognition(sender)
    }

    /// Rotates colors on single finger touch and saves the color to UserDefaults.
    func touchRecognition(_ sender: Any) {
        if (timeLbl.textColor == colorRotation.last) {
            colorRotationIndex = 0
        } else {
            colorRotationIndex += 1
        }


        impactor.impactOccurred()

        updateColor(colorRotation[colorRotationIndex])
        userSettings.set(colorRotationIndex, forKey: "LazyClock-ColorIndex")
    }
    #endif
}

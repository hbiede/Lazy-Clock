//
//  NatLangViewController.swift
//  Lazy Clock
//
//  Created by Hundter Biede on 8/26/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import Foundation
import UIKit
#if os(iOS)
import Intents
import os.log
#endif

class NatLangViewController: UIViewController {
    /// IBOutlets
    @IBOutlet var viewBG: UIView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var timerBGHeightCon: NSLayoutConstraint!

    /// Dictionary of the UIColors to be used in the rotation of the clock display.
    let colorRotation = [UIColor.white, UIColor.red, UIColor.blue, UIColor.green, UIColor.black]

    /// Index to use to cycle through colorRotation[] for the updating of the clock textColor. Defaults to 0.
    var colorRotationIndex:Int = 0

    #if os(iOS)
    /// Bool that determines if the clock will be displayed as natural language (False = Natural Time (Default), True = Short Time)
    var isShortLangDisplay = false

    /// ImpactFeedbackGenerator to be used to create haptic feedback.
    let impactor = UIImpactFeedbackGenerator.init()

    /// UserDefaults used to store settings for the app.
    let userSettings = UserDefaults.standard
    #endif

    /// DateFormatter to be used to update the time, either to the form of short or long form time.
    let dForm: DateFormatter = {
        let temp = DateFormatter()
        temp.dateFormat = "HH:mm:ss"
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        #if os(iOS)
        // Loads saved data for the clock
        colorRotationIndex = userSettings.integer(forKey: "LazyClock-ColorIndex")
        if colorRotationIndex >= colorRotation.count || colorRotationIndex < 0 {
            colorRotationIndex = 0
        }
        updateColor()
        isShortLangDisplay = userSettings.bool(forKey: "LazyClock-LazyTimeInactive")

        donateInteraction()
        #endif

        // Sets defaults for the timeLbl
        timeLbl.adjustsFontSizeToFitWidth = true
        timeLbl.adjustsFontForContentSizeCategory = true
        os_log("Lazy Clock Launched Successfully")

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
        #if os(iOS)
        if (isShortLangDisplay)
        {
            let tempArray = dForm.string(from: Date()).split(separator: ":")
            timeLbl.text = "\(tempArray[0]):\(tempArray[1])"
            let seconds: CGFloat! = CGFloat(Int(tempArray[2]) ?? 0)
            UIView.animate(withDuration: 1, animations: {
                self.timerBGHeightCon.constant = CGFloat(seconds / 60.0 * self.viewBG.frame.height)
                self.view.layoutIfNeeded()
                })
        } else {
            var natTime = NaturalLanguageTime.NatTime()
            natTime.timeString = dForm.string(from: Date())
            timeLbl.text = natTime.getNatLangString()
        }
        #elseif os(tvOS)
        var natTime = NaturalLanguageTime.NatTime()
        natTime.timeString = dForm.string(from: Date())
        timeLbl.text = natTime.getNatLangString()
        #endif
    }

    #if os(iOS)
    private func donateInteraction() {
        let intent = LazyClockIntent()

        intent.suggestedInvocationPhrase = "Lazy Time"

        let interaction = INInteraction(intent: intent, response: nil)

        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    os_log("Interaction donation failed: %@", log: OSLog.default, type: .error, error)
                }
            } else {
                os_log("Successfully donated interaction")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if userSettings.bool(forKey: "LazyClock-LazyTimeInactive") != isShortLangDisplay {
            shortTimeToggle()
        }
        updateTime()
    }


    /// Updates the color scheme.
    ///
    /// - Parameters:
    ///   - newColor: A UIColor to change the accent color to.
    func updateColor() {
        if (isShortLangDisplay)
        {
            viewBG.backgroundColor = UIColor.black
            timeLbl.textColor = UIColor.white
        } else {
            timeLbl.textColor = colorRotation[colorRotationIndex]
            if (timeLbl.textColor == UIColor.black) {
                viewBG.backgroundColor = UIColor.white
            } else {
                viewBG.backgroundColor = UIColor.black
            }
        }
    }

    func shortTimeToggle() {
        isShortLangDisplay.toggle()
        if !isShortLangDisplay {
            timerBGHeightCon.constant = 0.0
        }
        updateColor()
    }

    /// Rotates colors on single finger touch and saves the color to UserDefaults.
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        impactor.impactOccurred()
        colorRotationIndex += 1
        if (colorRotationIndex == colorRotation.count) {
            colorRotationIndex = 0
        }
        updateColor()
        userSettings.set(colorRotationIndex, forKey: "LazyClock-ColorIndex")
    }
    @IBAction func onSwipeUp(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    #endif
}

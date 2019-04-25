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
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var timerBGHeightCon: NSLayoutConstraint!
    @IBOutlet var timerColorBGView: UIView!
    
    #if os(iOS)
    /// Array of the UIColors to be used in the rotation of the clock display.
    let colorRotation = [UIColor.black, UIColor.white, UIColor(red: 0.639, green: 0.157, blue: 0.133, alpha: 1.0), UIColor(red: 0.24, green: 0.588, blue: 0.318, alpha: 1.0), UIColor(red: 0.133, green: 0.322, blue: 0.619, alpha: 1.0)] // black, white, red, green, blue
    
    /// Array of the UIColors to be used in the rotation of the timer BG color.
    let timerBGColorRotation = [UIColor(red: 0.639, green: 0.157, blue: 0.133, alpha: 1.0), UIColor(red: 0.24, green: 0.588, blue: 0.318, alpha: 1.0), UIColor(red: 0.133, green: 0.322, blue: 0.619, alpha: 1.0)] // red, green, blue

    /// Index to use to cycle through colorRotation[] for the updating of the clock textColor. Defaults to 0.
    var colorRotationIndex = 0
    
    /// Index to use to cycle through timerBGColorRotation[] for the updating of the timer BG color. Defaults to 0.
    var timerBGColorRotationIndex = 0

    /// Bool that determines if the clock will be displayed as natural language (False = Natural Time (Default), True = Short Time)
    static var isShortLangDisplay = false

    /// ImpactFeedbackGenerator to be used to create haptic feedback.
    let impactor = UIImpactFeedbackGenerator.init()

    /// UserDefaults used to store settings for the app.
    let userSettings = UserDefaults.standard
    #endif

    /// Natural Laguage Formatter
    var natTime = NaturalLanguageTime.NatTime()

    /// DateFormatter to be used to update the time, either to the form of short or long form time.
    let formatter: DateFormatter = {
        let temp = DateFormatter()
        temp.dateFormat = "HH:mm:ss"
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        #if os(iOS)
        // create gesture recognizers for the timer bg
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        doubleTapGesture.numberOfTouchesRequired = 2
        let mainTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        timeLbl.addGestureRecognizer(mainTapGesture)
        timeLbl.addGestureRecognizer(doubleTapGesture)
        mainTapGesture.require(toFail: doubleTapGesture)
        
        // Loads saved data for the clock
        colorRotationIndex = userSettings.integer(forKey: "LazyClock-ColorIndex")
        if colorRotationIndex >= colorRotation.count || colorRotationIndex < 0 {
            colorRotationIndex = 0
        }
        timerBGColorRotationIndex = userSettings.integer(forKey: "LazyClock-TimerBGColorIndex")
        if timerBGColorRotationIndex >= timerBGColorRotation.count || timerBGColorRotationIndex < 0 {
            timerBGColorRotationIndex = 0
        }
        updateColorViewBG()
        updateColorForTimerBG()
        
        NatLangViewController.isShortLangDisplay = userSettings.bool(forKey: "LazyClock-LazyTimeInactive")

        donateInteraction()
        #endif

        // Sets defaults for the timeLbl
        timeLbl.adjustsFontSizeToFitWidth = true
        timeLbl.adjustsFontForContentSizeCategory = true

        // Starts the clock on updating every second
        updateTime()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)

        os_log("Lazy Clock Launched Successfully")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Save the user settings
        userSettings.set(colorRotationIndex, forKey: "LazyClock-ColorIndex")
        userSettings.set(timerBGColorRotationIndex, forKey: "LazyClock-TimerBGColorIndex")
        userSettings.set(NatLangViewController.isShortLangDisplay, forKey: "LazyClock-LazyTimeInactive")
        os_log("Lazy Clock Closed Successfully")
    }

    func viewSet(label: UILabel!, bg: UIView!) {
        timeLbl = label
        backgroundView = bg
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    /// Updates time displayed on display. Called from Timer in viewDidLoad().
    @objc
    func updateTime() {
        #if os(iOS)
        timeLbl.numberOfLines = (NatLangViewController.isShortLangDisplay ? 1 : 2)
        if (NatLangViewController.isShortLangDisplay)
        {
            let tempArray = formatter.string(from: Date()).split(separator: ":")
            timeLbl.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
            let seconds: CGFloat! = CGFloat((Int(tempArray[2]) ?? 0) + 1)
            UIView.animate(withDuration: 1, animations: {
                self.timerBGHeightCon.constant = seconds / 60.0 * self.backgroundView.frame.height
                self.view.layoutIfNeeded()
                })
        } else {
            if (self.timerBGHeightCon.constant != 0) {
                self.timerBGHeightCon.constant = 0
            }
            natTime.timeString = formatter.string(from: Date())
            timeLbl.text = natTime.getNatLangString()
        }
        #elseif os(tvOS)
        natTime.timeString = formatter.string(from: Date())
        timeLbl.text = natTime.getNatLangString()
        #endif
    }

    #if os(iOS)
    private func donateInteraction() {
        let intent = LazyClockSpecifiedIntent()

        intent.suggestedInvocationPhrase = "Naturalize Clipboard"

        let interaction = INInteraction(intent: intent, response: nil)

        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    os_log("Clipboard interaction donation failed: %@", log: .default, type: .error, error)
                }
            } else {
                os_log("Successfully donated clipboard interaction")
            }
        }
    }
    
    @objc func onTap(sender: UITapGestureRecognizer) {
        print(sender)
        print(sender.numberOfTouches)
        for x in 0..<sender.numberOfTouches {
            if (sender.location(ofTouch: x, in: backgroundView).y.isLessThanOrEqualTo(CGFloat(self.timerBGHeightCon.constant))) {
                onTapTimerBG()
            } else {
                onTapMainView()
            }
        }
    }
    
    /// Rotates colors on single finger touch and saves the color to UserDefaults.
    func onTapMainView() {
        impactor.impactOccurred()
        colorRotationIndex += 1
        if (colorRotationIndex == colorRotation.count || (colorRotationIndex == 2 && NatLangViewController.isShortLangDisplay)) {
            // Prevent rollover or using colors on the blue progress bar
            colorRotationIndex = 0
        }
        updateColorViewBG()
        userSettings.set(colorRotationIndex, forKey: "LazyClock-ColorIndex")
    }

    /// Updates the color scheme.
    func updateColorViewBG() {
        timeLbl.textColor = colorRotation[colorRotationIndex]
        if (timeLbl.textColor == .black) {
            backgroundView.backgroundColor = .white
        } else {
            backgroundView.backgroundColor = .black
        }
    }
    
    /// Rotates colors on single finger touch and saves the color to UserDefaults.
    func onTapTimerBG() {
        impactor.impactOccurred()
        timerBGColorRotationIndex += 1
        if timerBGColorRotationIndex == timerBGColorRotation.count {
            // Prevent rollover
            timerBGColorRotationIndex = 0
        }
        updateColorForTimerBG()
        userSettings.set(timerBGColorRotationIndex, forKey: "LazyClock-TimerBGColorIndex")
    }

    /// Updates the color scheme for the timer BG.
    func updateColorForTimerBG() {
        timerColorBGView.backgroundColor = timerBGColorRotation[timerBGColorRotationIndex]
    }
    
    @IBAction func onSwipeUp(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    #endif
}

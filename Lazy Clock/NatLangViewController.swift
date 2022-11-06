//
//  NatLangViewController.swift
//  Lazy Clock
//
//  Created by Hundter Biede on 8/26/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import Foundation
import UIKit
import Intents
import os.log

class NatLangViewController: UIViewController {
    /// IBOutlets
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var timerBGHeightCon: NSLayoutConstraint!
    @IBOutlet var timerColorBGView: UIView!

    /// Index to use to cycle through colorRotation[] for the updating of the clock textColor. Defaults to 0.
    static var colorRotationIndex = 0

    /// Index to use to cycle through timerBGColorRotation[] for the updating of the timer BG color. Defaults to 0.
    static var timerBGColorRotationIndex = 0

    /// Bool that determines if the clock will be displayed as natural language
    /// (False = Natural Time (Default), True = Short Time)
    static var isShortLangDisplay = false

    /// ImpactFeedbackGenerator to be used to create haptic feedback.
    let impactor = UIImpactFeedbackGenerator.init()

    /// Natural Laguage Formatter
    var natTime = NaturalLanguageTime()

    /// DateFormatter to be used to update the time, either to the form of short or long form time.
    let formatter: DateFormatter = {
        let temp = DateFormatter()
        temp.dateFormat = "HH:mm:ss"
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // create gesture recognizers for the timer bg
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        doubleTapGesture.numberOfTouchesRequired = 2
        let mainTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        timeLbl.addGestureRecognizer(mainTapGesture)
        timeLbl.addGestureRecognizer(doubleTapGesture)
        mainTapGesture.require(toFail: doubleTapGesture)

        // Loads saved data for the clock
        NatLangViewController.colorRotationIndex =
            UserDefaults.standard.integer(forKey: "LazyClock-ColorIndex")
        if NatLangViewController.colorRotationIndex >= colorRotation.count ||
            NatLangViewController.colorRotationIndex < 0 {
            NatLangViewController.colorRotationIndex = 0
        }
        NatLangViewController.timerBGColorRotationIndex =
            UserDefaults.standard.integer(forKey: "LazyClock-TimerBGColorIndex")
        if NatLangViewController.timerBGColorRotationIndex >= timerBGColorRotation.count ||
            NatLangViewController.timerBGColorRotationIndex < 0 {
            NatLangViewController.timerBGColorRotationIndex = 0
        }
        updateColorViewBG()
        updateColorForTimerBG()

        NatLangViewController.isShortLangDisplay =
            UserDefaults.standard.bool(forKey: "LazyClock-LazyTimeInactive")

        // Sets defaults for the timeLbl
        timeLbl.adjustsFontSizeToFitWidth = true
        timeLbl.adjustsFontForContentSizeCategory = true

        // Starts the clock on updating every second
        updateTime()
        Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.updateTime),
            userInfo: nil,
            repeats: true
        )

        os_log("Lazy Clock Launched Successfully")
    }

    /// Prevent using colors on the blue progress bar or showing the bar when not intended after changing the
    /// setting of isShortLangDisplay
    override func viewWillAppear(_ animated: Bool) {
        if NatLangViewController.isShortLangDisplay {
            if NatLangViewController.colorRotationIndex >= 2 {
                NatLangViewController.colorRotationIndex = 0
            }
            updateColorViewBG()
        } else {
            self.timerBGHeightCon.constant = 0
        }
    }

    /// normal setup of a new app view controller
    override func becomeFirstResponder() -> Bool {
        return true
    }

    /// use the accessibilityScroll action to perform the equivalent of tapping the primary background
    override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        // increment in the direction of the scroll
        switch direction {
        case .down, .left, .previous:
            NatLangViewController.colorRotationIndex -= 1
        default:
            NatLangViewController.colorRotationIndex += 1
        }

        // Prevent rollover or using colors on the blue progress bar
        if NatLangViewController.colorRotationIndex == colorRotation.count ||
            (NatLangViewController.colorRotationIndex == 2 &&
                NatLangViewController.isShortLangDisplay) {
            NatLangViewController.colorRotationIndex = 0
        } else if NatLangViewController.colorRotationIndex == -1 {
            NatLangViewController.colorRotationIndex =
                NatLangViewController.isShortLangDisplay ? 1 : colorRotation.count - 1
        }
        updateColorViewBG()
        return true
    }

    /// Updates time displayed on display. Called from Timer in viewDidLoad().
    @objc
    func updateTime() {
        timeLbl.numberOfLines = (NatLangViewController.isShortLangDisplay ? 1 : 2)
        if NatLangViewController.isShortLangDisplay {
            timeLbl.text = DateFormatter.localizedString(
                from: Date(),
                dateStyle: .none,
                timeStyle: .short
            )

            let tempArray = formatter.string(from: Date())
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: ":")
            UIView.animate(withDuration: 1, animations: {
                // the below CGFloat represents the current seconds, thus the overall
                // math equaltion results in a the height of timerBG being set to a
                // proportion of the full height of the screen
                self.timerBGHeightCon.constant = CGFloat((Int(tempArray[2]) ?? 0) + 1) /
                    60.0 * self.backgroundView.frame.height
                self.view.layoutIfNeeded()
            })
        } else {
            natTime.timeString = formatter.string(from: Date())
            timeLbl.text = natTime.description
        }
    }

    /// Rotates the color of the time as well as the sliding background of the short time display
    @objc func onTap(sender: UITapGestureRecognizer) {
        var hasUpdatedBG       = false
        var hasUpdatedMainView = false
        for touch in 0..<sender.numberOfTouches {
            if sender.location(
                  ofTouch: touch,
                  in: backgroundView
                )
                    .y
                    .isLessThanOrEqualTo(CGFloat(self.timerBGHeightCon.constant))
                && !hasUpdatedBG {
                onTapTimerBG()
            	hasUpdatedBG = true
            } else if !hasUpdatedMainView {
                onTapMainView()
                hasUpdatedMainView = true
            }
        }
    }

    /// Rotates colors on single finger touch and saves the color to UserDefaults.
    func onTapMainView() {
        impactor.impactOccurred()
        NatLangViewController.colorRotationIndex += 1
        if NatLangViewController.colorRotationIndex == colorRotation.count ||
            (NatLangViewController.colorRotationIndex == 2 &&
             NatLangViewController.isShortLangDisplay) {
            // Prevent rollover or using colors on the blue progress bar
            NatLangViewController.colorRotationIndex = 0
        }
        updateColorViewBG()
    }

    /// Updates the color scheme.
    func updateColorViewBG() {
        timeLbl.textColor = colorRotation[NatLangViewController.colorRotationIndex]
        if timeLbl.textColor == .black {
            backgroundView.backgroundColor = .white
        } else {
            backgroundView.backgroundColor = .black
        }
    }

    /// Rotates colors on single finger touch and saves the color to UserDefaults.
    func onTapTimerBG() {
        impactor.impactOccurred()
        NatLangViewController.timerBGColorRotationIndex += 1
        if NatLangViewController.timerBGColorRotationIndex == timerBGColorRotation.count {
            // Prevent rollover
            NatLangViewController.timerBGColorRotationIndex = 0
        }
        updateColorForTimerBG()
    }

    /// Updates the color scheme for the timer BG.
    func updateColorForTimerBG() {
        timerColorBGView.backgroundColor = timerBGColorRotation[NatLangViewController.timerBGColorRotationIndex]
    }

    @IBAction func onSwipeUp(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

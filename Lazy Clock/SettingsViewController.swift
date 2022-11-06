//
//  SettingsView.swift
//  Lazy Clock
//
//  Created by Hundter Biede on 8/27/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import Foundation
import UIKit
import IntentsUI

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsSwitch: UISwitch!
    @IBOutlet weak var settingsSwitchLabel: UILabel!
    @IBOutlet weak var settingsViewBG: UIView!
    @IBOutlet weak var switchContainer: UIView!
    @IBOutlet weak var mainText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsSwitch.isOn = !UserDefaults.standard.bool(forKey: "LazyClock-LazyTimeInactive")
        settingsSwitch.tintColor = timerBGColorRotation[NatLangViewController.timerBGColorRotationIndex]
        settingsSwitchLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLabelTap)))
        mainText.sizeToFit()
    }

    override func accessibilityPerformEscape() -> Bool {
        self.dismiss(animated: true, completion: nil)
        return true
    }

    @IBAction func onChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(!settingsSwitch.isOn, forKey: "LazyClock-LazyTimeInactive")
        NatLangViewController.isShortLangDisplay = !settingsSwitch.isOn
    }
    @IBAction func onLabelTap(_ sender: UITapGestureRecognizer) {
        UserDefaults.standard.set(!settingsSwitch.isOn, forKey: "LazyClock-LazyTimeInactive")
        NatLangViewController.isShortLangDisplay = !settingsSwitch.isOn
    }
    @IBAction func onSwipeDown(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

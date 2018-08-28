//
//  SettingsView.swift
//  Lazy Clock
//
//  Created by Hundter Biede on 8/27/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var settingsSwitch: UISwitch!
    @IBOutlet var settingsViewBG: UIView!


    override func viewDidLoad() {
        settingsSwitch.isOn = !UserDefaults.standard.bool(forKey: "LazyClock-LazyTimeInactive")
    }

    @IBAction func onChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(!settingsSwitch.isOn, forKey: "LazyClock-LazyTimeInactive")
    }
    @IBAction func onSwipeDown(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

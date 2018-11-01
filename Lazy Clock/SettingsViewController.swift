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
    @IBOutlet var settingsSwitch: UISwitch!
    @IBOutlet var settingsViewBG: UIView!
    @IBOutlet var siriButtonContainer: UIView!
    @IBOutlet var switchContainer: UIView!
    @IBOutlet var siriButtonYConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsSwitch.isOn = !UserDefaults.standard.bool(forKey: "LazyClock-LazyTimeInactive")

        if (switchContainer.frame.maxY - siriButtonContainer.frame.maxY > 350) {
            siriButtonYConstraint.constant = 100
        }
        let siriButton = INUIAddVoiceShortcutButton(style: .black)
        siriButton.translatesAutoresizingMaskIntoConstraints = false
        siriButtonContainer.addSubview(siriButton)
        siriButton.addTarget(self, action: #selector(addToSiri(_:)), for: .touchUpInside)
    }

    @IBAction func onChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(!settingsSwitch.isOn, forKey: "LazyClock-LazyTimeInactive")
        NatLangViewController.isShortLangDisplay = !settingsSwitch.isOn
    }
    @IBAction func onSwipeDown(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func addToSiri(_ sender: Any) {
        if let shortcut = INShortcut(intent: LazyClockIntent()) {
            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            viewController.modalPresentationStyle = .formSheet
            present(viewController, animated: true, completion: nil)
        }
    }
}

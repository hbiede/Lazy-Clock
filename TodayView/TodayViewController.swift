//
//  TodayViewController.swift
//  TodayView
//
//  Created by Hundter Biede on 8/1/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    // UIView Object Outlets
    @IBOutlet weak var todayViewLbl: UILabel!

    /// DateFormatter to be used to update the time, either to the form of short or long form time.
    let dForm: DateFormatter = {
        let temp = DateFormatter()
        temp.dateFormat = "hh-mm"
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.

        updateTime()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        updateTime()
        completionHandler(NCUpdateResult.newData)
    }

    func updateTime() {
        var natTime = NaturalLanguageTime.NatTime()
        natTime.timeString = dForm.string(from: Date())
        todayViewLbl.text = natTime.getNatLangString()
    }
}

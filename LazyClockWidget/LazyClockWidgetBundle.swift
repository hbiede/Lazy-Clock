//
//  LazyClockWidgetBundle.swift
//  LazyClockWidget
//
//  Created by Hundter Biede on 11/5/22.
//  Copyright © 2022 Hundter Biede. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct LazyClockWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        LazyClockWidget()
    }
}

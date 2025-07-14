//
//  TimerBundle.swift
//  Timer
//
//  Created by Sergio Carbone on 14/7/25.
//

import WidgetKit
import SwiftUI

@main
struct TimerBundle: WidgetBundle {
    var body: some Widget {
        Timer()
        TimerLiveActivity()
    }
}

//
//  TimerAttributes.swift.swift
//  Runner
//
//  Created by Sergio Carbone on 12/7/25.
//
import ActivityKit

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}


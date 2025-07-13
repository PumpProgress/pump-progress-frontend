//
//  TimerLiveActivity.swift
//  Timer
//
//  Created by Sergio Carbone on 12/7/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

//struct TimerAttributes: ActivityAttributes {
//    public struct ContentState: Codable, Hashable {
//        // Dynamic stateful properties about your activity go here!
//        var emoji: String
//    }
//
//    // Fixed non-changing properties about your activity go here!
//    var name: String
//}

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            
            ZStack {
                VStack(spacing: 12) {
                    Text("\(context.state.name)")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text(context.state.startTime, style: .timer)
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                    Text("\(context.state.weight, specifier: "%.1f") kg x \(context.state.reps)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
            .activityBackgroundTint(.black)
            .activitySystemActionForegroundColor(.green)
                
            } dynamicIsland: { context in
                DynamicIsland {
                    // Expanded UI goes here.  Compose the expanded UI through
                    // various regions, like leading/trailing/center/bottom
                    DynamicIslandExpandedRegion(.leading) {
                        Text("Leading")
                    }
                    DynamicIslandExpandedRegion(.trailing) {
                        Text("Trailing")
                    }
                    DynamicIslandExpandedRegion(.bottom) {
                        Text("Bottom")
                        // more content
                    }
                } compactLeading: {
                    Text("L")
                } compactTrailing: {
                    Text("T")
                } minimal: {
                    Text("minimal")
                }
                .widgetURL(URL(string: "http://www.apple.com"))
                .keylineTint(Color.red)
            }
        }
    }

extension TimerAttributes {
    fileprivate static var preview: TimerAttributes {
        TimerAttributes(name: "World")
    }
}

extension TimerAttributes.ContentState {
    fileprivate static var smiley: TimerAttributes.ContentState {
        TimerAttributes.ContentState(name: "Bench Press", weight: 10.0, reps: 10, startTime: Date())
     }
     
     fileprivate static var starEyes: TimerAttributes.ContentState {
         TimerAttributes.ContentState(name: "Bench Press", weight: 10.0, reps: 10, startTime: Date())
     }
}

#Preview("Notification", as: .content, using: TimerAttributes.preview) {
   TimerLiveActivity()
} contentStates: {
    TimerAttributes.ContentState.smiley
    TimerAttributes.ContentState.starEyes
}

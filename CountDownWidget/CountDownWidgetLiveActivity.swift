//
//  CountDownWidgetLiveActivity.swift
//  CountDownWidget
//
//  Created by Bence Bodnár on 06/09/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CountDownWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CountDownWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CountDownWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CountDownWidgetAttributes {
    fileprivate static var preview: CountDownWidgetAttributes {
        CountDownWidgetAttributes(name: "World")
    }
}

extension CountDownWidgetAttributes.ContentState {
    fileprivate static var smiley: CountDownWidgetAttributes.ContentState {
        CountDownWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CountDownWidgetAttributes.ContentState {
         CountDownWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CountDownWidgetAttributes.preview) {
   CountDownWidgetLiveActivity()
} contentStates: {
    CountDownWidgetAttributes.ContentState.smiley
    CountDownWidgetAttributes.ContentState.starEyes
}

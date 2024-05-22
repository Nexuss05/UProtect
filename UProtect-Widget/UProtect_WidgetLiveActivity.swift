//
//  UProtect_WidgetLiveActivity.swift
//  UProtect-Widget
//
//  Created by Matteo Cotena on 21/05/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct UProtect_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct UProtect_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: UProtect_WidgetAttributes.self) { context in
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

extension UProtect_WidgetAttributes {
    fileprivate static var preview: UProtect_WidgetAttributes {
        UProtect_WidgetAttributes(name: "World")
    }
}

extension UProtect_WidgetAttributes.ContentState {
    fileprivate static var smiley: UProtect_WidgetAttributes.ContentState {
        UProtect_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: UProtect_WidgetAttributes.ContentState {
         UProtect_WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: UProtect_WidgetAttributes.preview) {
   UProtect_WidgetLiveActivity()
} contentStates: {
    UProtect_WidgetAttributes.ContentState.smiley
    UProtect_WidgetAttributes.ContentState.starEyes
}

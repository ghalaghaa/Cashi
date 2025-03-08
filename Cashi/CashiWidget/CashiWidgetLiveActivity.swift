//
//  CashiWidgetLiveActivity.swift
//  CashiWidget
//
//  Created by Ghala Alnemari on 08/09/1446 AH.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CashiWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CashiWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CashiWidgetAttributes.self) { context in
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

extension CashiWidgetAttributes {
    fileprivate static var preview: CashiWidgetAttributes {
        CashiWidgetAttributes(name: "World")
    }
}

extension CashiWidgetAttributes.ContentState {
    fileprivate static var smiley: CashiWidgetAttributes.ContentState {
        CashiWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CashiWidgetAttributes.ContentState {
         CashiWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CashiWidgetAttributes.preview) {
   CashiWidgetLiveActivity()
} contentStates: {
    CashiWidgetAttributes.ContentState.smiley
    CashiWidgetAttributes.ContentState.starEyes
}

//
//  UProtect_Widget.swift
//  UProtect-Widget
//
//  Created by Matteo Cotena on 21/05/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}


struct UProtect_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            HStack {
                Text("TAP")
                    .foregroundStyle(.orange)
                    .fontWeight(.bold)
//                    .font(.title)
//                    .offset(x: 0, y: -150)
                Text("to SOS mode")
//                    .font(.title2)
                    .fontWeight(.bold)
//                    .offset(x: 0, y: -150)
            }
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .opacity(0.3)
                    .frame(width: 220)
                Circle()
                    .foregroundColor(.white)
                    .opacity(0.3)
                    .frame(width: 220)
                    .shadow(color: .gray, radius: 4)
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 55, height: 50)
                    .foregroundColor(.orange)
                    .opacity(1)
                    .opacity(withAnimation{1})
            }//fine bottone
        }
    }
}

struct UProtect_Widget: Widget {
    let kind: String = "UProtect_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            UProtect_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
}

#Preview(as: .systemSmall) {
    UProtect_Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
}

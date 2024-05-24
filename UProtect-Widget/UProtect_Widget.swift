//
//  UProtect_Widget.swift
//  UProtect-Widget
//
//  Created by Matteo Cotena on 21/05/24.
//

import SwiftUI
import WidgetKit

struct CustomWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "UProtect_Widget", provider: Provider()) { entry in
            WidgetView()
        }
        .configurationDisplayName("UProtect Widget")
        .description("Widget per attivare l'SOS")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

struct WidgetView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        HStack {
            if widgetFamily == .systemMedium || widgetFamily == .systemLarge {
                
                    ZStack{
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 120)
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 55, height: 50)
                            .foregroundColor(.red)
                            .opacity(1)
                    }
                .offset(CGSize(width: -10, height: 0))
                VStack {
                    Text("TAP")
                        .foregroundStyle(.red)
                        .fontWeight(.bold)
                        .font(.title)
                    Text("to receive help")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center)
            } else if widgetFamily == .systemSmall {
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 120)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 55, height: 50)
                        .foregroundColor(.red)
                        .opacity(1)
                }
            }
        }
        .widgetURL(URL(string: "widget://sos"))
        //        .background(Color.red) // Modifica il colore di sfondo per il debug
        .widgetBackground(Color.black)
    }
}

// Aggiunta della struttura PreviewProvider per mostrare un'anteprima del widget
struct UProtect_Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        WidgetView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

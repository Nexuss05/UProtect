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
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular])
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
                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                    //                            .shadow(color: .gray, radius: 6)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 55, height: 50)
                        .foregroundColor(CustomColor.orange)
                        .opacity(1)
                }
                .offset(CGSize(width: -10, height: 0))
                VStack {
                    Text("TAP")
                        .foregroundStyle(CustomColor.orange)
                        .fontWeight(.bold)
                        .font(.title)
                    Text("to send an alert")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .multilineTextAlignment(.center)
            } else if widgetFamily == .systemSmall {
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 120)
                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                    //                        .shadow(color: .gray, radius: 6)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 55, height: 50)
                        .foregroundColor(CustomColor.orange)
                        .opacity(1)
                }
            } else if widgetFamily == .accessoryCircular {
                ZStack{
                    Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 120)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 30, height: 28)
                }
            }
        }
        .widgetURL(URL(string: "widget://sos"))
        //        .background(Color.red) // Modifica il colore di sfondo per il debug
                .widgetBackground(CustomColor.orangeBackground)
//        .widgetBackground(Color.black)
    }
}

struct CustomColor {
    static let orange = Color("CustomOrange")
    static let orangeBackground = Color("OBackground")
    static let redBackground = Color("RBackground")
}

// Aggiunta della struttura PreviewProvider per mostrare un'anteprima del widget
struct UProtect_Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        WidgetView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        WidgetView()
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}


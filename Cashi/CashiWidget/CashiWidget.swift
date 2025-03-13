//
//  CashiWidget.swift
//  CashiWidget
//
//  Created by Ghala Alnemari on 08/09/1446 AH.
//


import WidgetKit
import SwiftUI
import AppIntents

struct IncreaseProgressIntent: AppIntent {
    static var title: LocalizedStringResource = "Increase Progress"

    func perform() async throws -> some IntentResult {
        let key = "widget_progress"
        var progress = UserDefaults.standard.double(forKey: key)
        progress = min(progress + 0.1, 1.0)
        
        UserDefaults.standard.set(progress, forKey: key)
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result()
    }
}

struct DecreaseProgressIntent: AppIntent {
    static var title: LocalizedStringResource = "Decrease Progress"

    func perform() async throws -> some IntentResult {
        let key = "widget_progress"
        var progress = UserDefaults.standard.double(forKey: key)
        progress = max(progress - 0.1, 0.0)
        
        UserDefaults.standard.set(progress, forKey: key)
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result()
    }
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(progress: 0.4)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let progress = UserDefaults.standard.double(forKey: "widget_progress")
        return SimpleEntry(progress: progress)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let progress = UserDefaults.standard.double(forKey: "widget_progress")
        let entry = SimpleEntry(progress: progress)
        return Timeline(entries: [entry], policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date = Date()
    let progress: Double
}

struct CashiWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "1A1F71"), Color(hex: "01010A")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .ignoresSafeArea()

            VStack(spacing: 9) {
                HStack {
                    Text("Trip Goal")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .offset(x: -10, y: 5)
                    Spacer()
                }
                .padding(.leading, 10)

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.4), lineWidth: 8)
                        .frame(width: 70, height: 70)

                    Circle()
                        .trim(from: 0, to: entry.progress)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "4A90E2"), Color(hex: "A67CFF")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(-90))

                    Text("🏝️")
                        .font(.system(size: 22))
                }
                .padding(.vertical, 5)

                HStack(spacing: 50) {
                    Button(intent: DecreaseProgressIntent()) {
                        Circle()
                            .fill(Color(hex: "4A90E2").opacity(0.9))
                            .frame(width: 22, height: 22)
                            .overlay(
                                Image(systemName: "minus")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            )
                    }

                    Button(intent: IncreaseProgressIntent()) {
                        Circle()
                            .fill(Color(hex: "4A90E2").opacity(0.9))
                            .frame(width: 22, height: 22)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.top, -15)
            }
            .padding()
        }
        .containerBackground(Color.clear, for: .widget)
    }
}

// ✅ إعداد الودجت
struct CashiWidget: Widget {
    let kind: String = "CashiWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CashiWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("CashTrack")
        .description("تعقب هدف رحلتك بسهولة.")
        .supportedFamilies([.systemSmall])
    }
}

// ✅ دعم الألوان من HEX
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

#Preview(as: .systemSmall) {
    CashiWidget()
} timeline: {
    SimpleEntry(progress: 0.4)
}

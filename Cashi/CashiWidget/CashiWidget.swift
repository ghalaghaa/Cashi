//
//  CashiWidget.swift
//  CashiWidget
//
//  Created by Ghala Alnemari on 08/09/1446 AH.
//
//
//  CashiWidget.swift
//  CashiWidget
//

import WidgetKit
import SwiftUI
import AppIntents
import CloudKit




// MARK: - AppIntents
struct IncreaseProgressIntent: AppIntent {
    static var title: LocalizedStringResource = "Increase Progress"
    
    func perform() async throws -> some IntentResult {
        await GoalWidgetManager.shared.updateProgress(increase: true)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct DecreaseProgressIntent: AppIntent {
    static var title: LocalizedStringResource = "Decrease Progress"
    
    func perform() async throws -> some IntentResult {
        await GoalWidgetManager.shared.updateProgress(increase: false)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

// MARK: - Timeline Provider
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(progress: 0.4, goalName: "Goal", goalEmoji: "🎯")    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let (name, progress, emoji) = await fetchGoalData()
        return SimpleEntry(progress: progress, goalName: name, goalEmoji: emoji)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let (name, progress, emoji) = await fetchGoalData()
        print("📊 Timeline updated with goal: \(name) – progress: \(progress)")
        let entry = SimpleEntry(progress: progress, goalName: name, goalEmoji: emoji)
        return Timeline(entries: [entry], policy: .atEnd)
    }
    
    private func fetchGoalData() async -> (String, Double, String) {
        await withCheckedContinuation { continuation in
            GoalWidgetManager.shared.fetchLatestIndividualGoal { name, progress, emoji in
                continuation.resume(returning: (name, progress, emoji))
            }
        }
    }
}

// MARK: - Entry
struct SimpleEntry: TimelineEntry {
    let date = Date()
    let progress: Double
    let goalName: String
    let goalEmoji: String
}

// MARK: - Widget View
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
                    Text(entry.goalName)
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

                    let safeProgress = entry.progress.isFinite && entry.progress >= 0 ? min(entry.progress, 1.0) : 0

                    Circle()
                        .trim(from: 0, to: safeProgress)
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
                        .animation(.easeInOut(duration: 0.3), value: safeProgress)
                        
                        
                    Text(entry.goalEmoji)
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

// MARK: - Widget Configuration
struct CashiWidget: Widget {
    let kind: String = "CashiWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CashiWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("CashTrack")
        .description("تعقب هدفك الفردي بسهولة.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Hex Color Extension
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

// MARK: - CloudKit Manager
class GoalWidgetManager {
    static let shared = GoalWidgetManager()
    let container = CKContainer(identifier: "iCloud.CashiBackup")
    lazy var database = container.publicCloudDatabase

    func fetchLatestIndividualGoal(completion: @escaping (String, Double, String) -> Void) {
        let predicate = NSPredicate(format: "goalType == %@ AND isWidgetGoal == %@", "individual", "true")
        let query = CKQuery(recordType: "Goal", predicate: predicate)

        database.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                print("⚠️ Error fetching goal: \(error.localizedDescription)")
                completion("No Goal", 0.0, "❌")
                return
            }

            if let goal = results?.first {
                let name = goal["name"] as? String ?? "Unnamed Goal"
                let cost = goal["cost"] as? Double ?? 1
                let collected = goal["collectedAmount"] as? Double ?? 0
                let emoji = goal["emoji"] as? String ?? "🎯"
                let progress = cost > 0 ? collected / cost : 0
                print("✅ Goal fetched: \(name), progress: \(progress), emoji: \(emoji)")
                completion(name, progress, emoji)
            } else {
                print("⚠️ No individual goals found in CloudKit")
                completion("No Goal", 0.0, "❌")
            }
        }
    }
    func updateProgress(increase: Bool) async {
        let predicate = NSPredicate(format: "goalType == %@", "individual")
        let query = CKQuery(recordType: "Goal", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        do {
            let records = try await database.perform(query, inZoneWith: nil)
            guard let goal = records.first else {
                print("❌ No individual goal found to update")
                return
            }

            // ✅ جلب أحدث نسخة من السجل
            let latestRecord = try await database.record(for: goal.recordID)

            let currentCollected = latestRecord["collectedAmount"] as? Double ?? 0
            let cost = latestRecord["cost"] as? Double ?? 1

            // ✅ رفع القيمة تدريجيًا لإحساس بالحركة
            let amountToAdd: Double = increase ? 10 : -10
            let newCollected = min(max(currentCollected + amountToAdd, 0), cost)

            latestRecord["collectedAmount"] = newCollected
            try await database.save(latestRecord)

            print("✅ Progress updated to: \(newCollected)")

            // ✅ إعادة تحميل الودجت لإظهار التقدم
            WidgetCenter.shared.reloadAllTimelines()

        } catch {
            print("❌ Error updating progress: \(error)")
        }
    }
}
// MARK: - Preview
#Preview(as: .systemSmall) {
    CashiWidget()
} timeline: {
    SimpleEntry(progress: 0.4, goalName: "Trip to Bali", goalEmoji: "🌴")
}

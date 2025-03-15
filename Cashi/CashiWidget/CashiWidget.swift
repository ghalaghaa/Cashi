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

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(progress: 0.4, goalName: "Goal")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let (name, progress) = await fetchGoalData()
        return SimpleEntry(progress: progress, goalName: name)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let (name, progress) = await fetchGoalData()
        let entry = SimpleEntry(progress: progress, goalName: name)
        return Timeline(entries: [entry], policy: .atEnd)
    }

    private func fetchGoalData() async -> (String, Double) {
        await withCheckedContinuation { continuation in
            GoalWidgetManager.shared.fetchLatestIndividualGoal { name, progress in
                continuation.resume(returning: (name, progress))
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date = Date()
    let progress: Double
    let goalName: String

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

                    // ✅ حماية القيمة من أن تكون غير صالحة
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


import CloudKit

class GoalWidgetManager {
    static let shared = GoalWidgetManager()
    let container = CKContainer(identifier: "iCloud.CashiBackup")
    lazy var database = container.publicCloudDatabase

    /// ✅ Fetch the latest individual goal with name and progress
    func fetchLatestIndividualGoal(completion: @escaping (String, Double) -> Void) {
        let predicate = NSPredicate(format: "goalType == %@", "individual")
        let query = CKQuery(recordType: "Goal", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        database.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                print("⚠️ Error fetching goal: \(error.localizedDescription)")
                completion("No Goal", 0.0)
                return
            }

            guard let goal = results?.first else {
                completion("No Goal", 0.0)
                return
            }

            let name = goal["name"] as? String ?? "Unnamed Goal"
            let cost = goal["cost"] as? Double ?? 1
            let collected = goal["collectedAmount"] as? Double ?? 0
            let progress = cost > 0 ? collected / cost : 0
            completion(name, progress)
        }
    }

    /// ✅ Simple method if you only want progress (without name)
    func fetchProgress(completion: @escaping (Double) -> Void) {
        fetchLatestIndividualGoal { _, progress in
            completion(progress)
        }
    }

    /// ✅ Update collectedAmount for latest individual goal
    func updateProgress(increase: Bool) async {
        let predicate = NSPredicate(format: "goalType == %@", "individual")
        let query = CKQuery(recordType: "Goal", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        do {
            let records = try await database.perform(query, inZoneWith: nil)
            guard let goal = records.first else { return }

            let currentCollected = goal["collectedAmount"] as? Double ?? 0
            let cost = goal["cost"] as? Double ?? 1
            let newCollected = min(max(currentCollected + (increase ? 10 : -10), 0), cost)

            goal["collectedAmount"] = newCollected
            _ = try await database.save(goal)

        } catch {
            print("⚠️ Error updating goal progress: \(error)")
        }
    }
}
#Preview(as: .systemSmall) {
    CashiWidget()
} timeline: {
    SimpleEntry(progress: 0.4, goalName: "Trip to Bali")
}

import CloudKit
import Foundation

struct Goal {
    var id: CKRecord.ID
    var name: String
    var cost: Double
    var salary: Double
    var emoji: String
    var goalType: GoalType
    var imageData: Data?
    var savingsType: SavingsType

    enum SavingsType: String, CaseIterable {
        case daily, weekly, monthly
    }

    enum GoalType: String, CaseIterable {
        case individual, qattah, challenge
    }

    // ✅ Safe Initialization
    init(id: CKRecord.ID, name: String, cost: Double?, salary: Double?, savingsType: SavingsType, emoji: String, goalType: GoalType, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.cost = cost ?? 0.0
        self.salary = salary ?? 0.0
        self.savingsType = savingsType
        self.emoji = emoji
        self.goalType = goalType
        self.imageData = imageData
    }

    // ✅ Fetch Goal from CloudKit Record
    init?(record: CKRecord) {
        guard let name = record["name"] as? String,
              let savingsTypeRaw = record["savingsType"] as? String,
              let savingsType = SavingsType(rawValue: savingsTypeRaw),
              let emoji = record["emoji"] as? String,
              let goalTypeRaw = record["goalType"] as? String,
              let goalType = GoalType(rawValue: goalTypeRaw) else {
            print("⚠️ Missing fields in Goal record -> \(record.recordID.recordName)")
            return nil
        }

        self.id = record.recordID
        self.name = name
        self.cost = record["cost"] as? Double ?? 0.0
        self.salary = record["salary"] as? Double ?? 0.0
        self.savingsType = savingsType
        self.emoji = emoji
        self.goalType = goalType
        self.imageData = nil

        if let asset = record["imageData"] as? CKAsset, let fileURL = asset.fileURL {
            do {
                self.imageData = try Data(contentsOf: fileURL)
            } catch {
                print("⚠️ Failed to load image data: \(error.localizedDescription)")
            }
        }
    }
}

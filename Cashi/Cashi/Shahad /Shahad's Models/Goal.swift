import CloudKit
import Foundation

struct Goal:Identifiable,Equatable {
    var id: CKRecord.ID
    var name: String
    var cost: Double
    var salary: Double
    var emoji: String
    var goalType: GoalType
    var imageData: Data?
    var savingsType: SavingsType
    var participants: Int? // ✅ عدد المشاركين في Qattah فقط
    var collectedAmount: Double // ✅ تتبع المبلغ المجمع
    var modifiedDate: Date?
    
    
    enum SavingsType: String, CaseIterable {
        case daily, weekly, monthly
    }

    enum GoalType: String, CaseIterable {
        case individual, qattah, challenge
    }

    // ✅ Safe Initialization
    init(id: CKRecord.ID, name: String, cost: Double?, salary: Double?, savingsType: SavingsType, emoji: String, goalType: GoalType, imageData: Data? = nil , collectedAmount: Double = 0.0) {
        self.id = id
        self.name = name
        self.cost = cost ?? 0.0
        self.salary = salary ?? 0.0
        self.savingsType = savingsType
        self.emoji = emoji
        self.goalType = goalType
        self.imageData = imageData
//        self.participants = nil
        self.collectedAmount = collectedAmount

    }

    // ✅ Fetch Goal from CloudKit Record
    init?(record: CKRecord) {
        guard let name = record["name"] as? String,
              let savingsTypeRaw = record["savingsType"] as? String,
              let savingsType = SavingsType(rawValue: savingsTypeRaw),
              let emoji = record["emoji"] as? String,
              let cost = record["cost"] as? Double,
//              let collectedAmount = record["collectedAmount"] as? Double, // ✅ استرجاع المبلغ المجمع
//              let salary = record["salary"] as? Double, // ✅ تأكد من استرجاع الراتب

              let goalTypeRaw = record["goalType"] as? String,
              let goalType = GoalType(rawValue: goalTypeRaw) else {
            print("⚠️ Missing fields in Goal record -> \(record.recordID.recordName)")
            return nil
        }

        self.id = record.recordID
        self.name = name
        self.cost = record["cost"] as? Double ?? 0.0
        self.collectedAmount = record["collectedAmount"] as? Double ?? 0.0
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
    // ✅ *تحويل Goal إلى CKRecord للحفظ في CloudKit*
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Goal", recordID: id)
        record["name"] = name as CKRecordValue
        record["cost"] = cost as CKRecordValue
        record["collectedAmount"] = collectedAmount as CKRecordValue // ✅ حفظ المبلغ المجمع
        record["salary"] = salary as CKRecordValue // ✅ حفظ الراتب
        record["savingsType"] = savingsType.rawValue as CKRecordValue
        record["emoji"] = emoji as CKRecordValue
        record["goalType"] = goalType.rawValue as CKRecordValue

        if let imageData = imageData, let fileURL = saveImageToTemporaryURL(data: imageData) {
            record["imageData"] = CKAsset(fileURL: fileURL)
        }
        return record
    }

    // ✅ *حفظ الصورة كملف مؤقت قبل رفعها إلى CloudKit*
    private func saveImageToTemporaryURL(data: Data) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")

        do {
            try data.write(to: fileURL, options: .atomic)
            return fileURL
        } catch {
            print("⚠️ Failed to save image: \(error.localizedDescription)")
            return nil
        }
    }
}



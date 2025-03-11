//
//  Calculation.swift
//  Cashi
//
//  Created by Shahad Abdulmohsen on 11/09/1446 AH.
//

import CloudKit
import Foundation

struct Calculation {
    let id: CKRecord.ID
    let goalName: String
    let cost: Double
    var salary: Double
    let savingsRequired: Double
    let savingsType: Goal.SavingsType
    let emoji: String

    // ✅ تهيئة من `CKRecord` مع معالجة الأخطاء
    init?(record: CKRecord) {
        print("📝 Fetching Calculation Record: \(record.recordID.recordName)")

        self.id = record.recordID

        if let goalName = record["goalName"] as? String,
           let emoji = record["emoji"] as? String {
            self.goalName = goalName
            self.emoji = emoji
            UserDefaults.standard.set(goalName, forKey: "lastValidGoalName")
            UserDefaults.standard.set(emoji, forKey: "lastValidGoalEmoji")
        } else {
            print("⚠️ Error: Missing `goalName` or `emoji`. Attempting to recover...")

            if let lastGoalName = UserDefaults.standard.string(forKey: "lastValidGoalName"),
               let lastEmoji = UserDefaults.standard.string(forKey: "lastValidGoalEmoji") {
                self.goalName = lastGoalName
                self.emoji = lastEmoji
                print("✅ Using last known valid goal data: \(lastGoalName) \(lastEmoji)")
            } else {
                print("❌ Unable to recover missing fields. Skipping record.")
                return nil
            }
        }

        self.cost = (record["cost"] as? NSNumber)?.doubleValue ?? 0.0
        self.salary = (record["salary"] as? NSNumber)?.doubleValue ?? 0.0
        self.savingsRequired = (record["savingsRequired"] as? NSNumber)?.doubleValue ?? 0.0

        if let savingsTypeRaw = record["savingsType"] as? String,
           let savingsType = Goal.SavingsType(rawValue: savingsTypeRaw) {
            self.savingsType = savingsType
            UserDefaults.standard.set(savingsTypeRaw, forKey: "lastValidSavingsType")
        } else {
            print("⚠️ Warning: `savingsType` is missing or invalid in \(record.recordID.recordName). Setting default to last known valid type.")

            if let lastValidSavingsType = UserDefaults.standard.string(forKey: "lastValidSavingsType"),
               let validType = Goal.SavingsType(rawValue: lastValidSavingsType) {
                self.savingsType = validType
            } else {
                self.savingsType = .monthly // ✅ تعيين القيمة الافتراضية
            }
        }

        print("✅ Calculation initialized successfully: \(self)")
    }
    // ✅ تحويل `Calculation` إلى `CKRecord` للحفظ في iCloud
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Calculations", recordID: id)

        record["goalName"] = goalName as CKRecordValue
        record["cost"] = NSNumber(value: cost)
        record["salary"] = NSNumber(value: salary)
        record["savingsRequired"] = NSNumber(value: savingsRequired)

        // ✅ التأكد من أن `savingsType` صالح قبل الحفظ
        if Goal.SavingsType.allCases.map({ $0.rawValue }).contains(savingsType.rawValue) {
            record["savingsType"] = savingsType.rawValue as CKRecordValue
        } else {
            print("⚠️ Warning: Invalid `savingsType` value. Using default `monthly`.")
            record["savingsType"] = Goal.SavingsType.monthly.rawValue as CKRecordValue
        }

        record["emoji"] = emoji as CKRecordValue
        return record
    }
}


//
//  ContentView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
//

import SwiftUI
import CloudKit

struct Goal: Identifiable {
    let id: CKRecord.ID
    var name: String
    var cost: Double
    var salary : Double = 0
    var savingsType: SavingsType
    var emoji: String
    var imageData: Data?

    // ✅ Define SavingsType Inside the Model
    enum SavingsType: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
    }

    // ✅ Custom Initializer
    init(id: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), name: String, cost: Double,salary: Double = 0, savingsType: SavingsType, emoji: String, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.cost = cost
        self.salary = salary
        self.savingsType = savingsType
        self.emoji = emoji
        self.imageData = imageData
    }

    // ✅ Initialize from CloudKit record
    init(record: CKRecord) {
        self.id = record.recordID
        self.name = record["name"] as? String ?? ""
        self.cost = record["cost"] as? Double ?? 0.0
        self.salary = record["salary"]as? Double ?? 0.0
        self.savingsType = SavingsType(rawValue: record["savingsType"] as? String ?? "Monthly") ?? .monthly
        self.emoji = record["emoji"] as? String ?? "🎯"

        if let asset = record["image"] as? CKAsset, let fileURL = asset.fileURL {
            self.imageData = try? Data(contentsOf: fileURL)
        } else {
            self.imageData = nil
        }
    }

    // ✅ Convert Goal to CKRecord for saving to CloudKit
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Goal", recordID: id)
        record["name"] = name as CKRecordValue
        record["cost"] = cost as CKRecordValue
        record["salary"] = salary as CKRecordValue
        record["savingsType"] = savingsType.rawValue as CKRecordValue
        record["emoji"] = emoji as CKRecordValue

        if let imageData = imageData {
            let asset = CKAsset(fileURL: saveImageToTemporaryURL(data: imageData))
            record["image"] = asset
        }

        return record
    }

    // ✅ Save Image to Temporary URL for CKAsset
    private func saveImageToTemporaryURL(data: Data) -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        do {
            try data.write(to: fileURL)
        } catch {
            print("⚠️ فشل في حفظ الصورة: \(error.localizedDescription)")
        }
        return fileURL
    }
}

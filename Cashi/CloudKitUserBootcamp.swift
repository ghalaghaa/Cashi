//
//  CloudKitUserBootcamp.swift
//  Cashi
//
//  Created by Ghala Alnemari on 27/08/1446 AH.
//
//

import SwiftUI
import CloudKit
import Foundation
import UIKit

// MARK: - User Model
struct User {
    static let recordType = "User"
    let id: CKRecord.ID
    let name: String
    let email: String
    let profilePicture: CKAsset?
    
    init?(record: CKRecord) {
        guard let name = record["name"] as? String,
              let email = record["email"] as? String else { return nil }
        
        self.id = record.recordID
        self.name = name
        self.email = email
        self.profilePicture = record["profilePicture"] as? CKAsset
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: User.recordType, recordID: id)
        record["name"] = name as CKRecordValue
        record["email"] = email as CKRecordValue
        if let profilePicture = profilePicture {
            record["profilePicture"] = profilePicture
        }
        return record
    }
}

// MARK: - CloudKit Model
import Foundation
import CloudKit

final class Model: ObservableObject {
    static let current = Model()
    private let database = CKContainer.default().publicCloudDatabase

    @Published private(set) var users: [User] = []
    @Published private(set) var establishments: [Establishment] = []

    func refreshEstablishments() async throws {
        let query = CKQuery(recordType: Establishment.recordType, predicate: .init(value: true))
        let records = try await database.records(matching: query).matchResults.map { try $1.get() }
        DispatchQueue.main.async {
            self.establishments = records.compactMap { Establishment(record: $0, database: self.database) }
        }
    }

    func addUser(name: String, email: String, profileImage: UIImage?) async throws {
        let recordID = CKRecord.ID()
        let record = CKRecord(recordType: User.recordType, recordID: recordID)
        record["name"] = name as CKRecordValue
        record["email"] = email as CKRecordValue

        if let image = profileImage, let imageData = image.jpegData(compressionQuality: 0.8) {
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
            try imageData.write(to: fileURL)
            let asset = CKAsset(fileURL: fileURL)
            record["profilePicture"] = asset
        }

        try await database.save(record)
        try await fetchUsers()
    }

    func fetchUsers() async throws {
        let query = CKQuery(recordType: User.recordType, predicate: .init(value: true))
        let records = try await database.records(matching: query).matchResults.map { try $1.get() }
        DispatchQueue.main.async {
            self.users = records.compactMap { User(record: $0) }
        }
    }
}

struct Establishment {
    static let recordType = "Establishment"
    let id: CKRecord.ID
    let name: String
    let database: CKDatabase
    
    init?(record: CKRecord, database: CKDatabase) {
        guard let name = record["name"] as? String else { return nil }
        self.id = record.recordID
        self.name = name
        self.database = database
    }
}

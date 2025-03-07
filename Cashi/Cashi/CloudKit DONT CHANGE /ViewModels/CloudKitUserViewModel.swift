//
//  CloudKitUserViewModel.swift
//  Cashi
//
//  Created by Ghala Alnemari on 02/09/1446 AH.
//

import Foundation
import CloudKit
import SwiftUI

class CloudKitUserViewModel: ObservableObject {
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    @Published var users: [User] = []
    @Published var currentUser: User?
    
    private let container = CKContainer(identifier: "iCloud.CashiBackup")
    private let database: CKDatabase

    init() {
        self.database = container.publicCloudDatabase
        
        print("📡 التحقق من حالة iCloud...")
        getiCloudStatus()
        fetchiCloudUserRecordID()
    }

    private func getiCloudStatus() {
        container.accountStatus { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                switch returnedStatus {
                case .available:
                    print("✅ iCloud متاح!")
                    self?.isSignedInToiCloud = true
                case .noAccount:
                    print("❌ لا يوجد حساب iCloud")
                    self?.error = CloudKitError.iCloudAccountNotFound.rawValue
                case .couldNotDetermine:
                    print("❌ تعذر تحديد حالة حساب iCloud")
                    self?.error = CloudKitError.iCloudAccountNotDetermined.rawValue
                case .restricted:
                    print("❌ حساب iCloud مقيد")
                    self?.error = CloudKitError.iCloudAccountRestricted.rawValue
                default:
                    print("❌ حالة iCloud غير معروفة")
                    self?.error = CloudKitError.iCloudAccountUnknown.rawValue
                }
            }
        }
        enum CloudKitError: String, LocalizedError {
                case iCloudAccountNotFound = "لم يتم العثور على حساب iCloud"
                case iCloudAccountNotDetermined = "تعذر تحديد حالة حساب iCloud"
                case iCloudAccountRestricted = "حساب iCloud مقيد"
                case iCloudAccountUnknown = "حالة حساب iCloud غير معروفة"
            }
    }

    func fetchiCloudUserRecordID() {
        print("🔍 محاولة جلب معرف المستخدم من iCloud...")
        container.fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID {
                print("✅ تم العثور على معرف المستخدم: \(id.recordName)")
                self?.discoveriCloudUser(id: id)
            } else if let error = returnedError {
                print("❌ خطأ أثناء جلب معرف المستخدم: \(error.localizedDescription)")
            }
        }
    }

    func discoveriCloudUser(id: CKRecord.ID) {
        container.discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    print("✅ تم العثور على اسم المستخدم في iCloud: \(name)")
                    self?.userName = name
                } else if let error = returnedError {
                    print("❌ خطأ أثناء جلب هوية المستخدم: \(error.localizedDescription)")
                }
            }
        }
    }

    func addUser(name: String, email: String) async throws {
        let record = CKRecord(recordType: "ADDUsers")
        record["name"] = name as CKRecordValue
        record["email"] = email as CKRecordValue

        print("📤 جاري حفظ المستخدم في CloudKit...")
        let saveOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        saveOperation.savePolicy = .allKeys
        saveOperation.qualityOfService = .userInitiated

        try await database.modifyRecords(saving: [record], deleting: [])
        print("✅ تم حفظ المستخدم في CloudKit بنجاح!")
    }

    func fetchUsers() async throws {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ADDUsers", predicate: predicate)

        do {
            print("🔍 جاري البحث عن المستخدمين في CloudKit...")
            let (results, _) = try await database.records(matching: query)

            let fetchedUsers = results.compactMap { _, result -> User? in
                switch result {
                case .success(let record):
                    let user = User(record: record)
                    print("📌 تم استرجاع المستخدم: \(user?.name ?? "بدون اسم") - \(user?.email ?? "بدون بريد")")
                    return user
                case .failure(let error):
                    print("❌ خطأ أثناء جلب المستخدم: \(error.localizedDescription)")
                    return nil
                }
            }

            DispatchQueue.main.async {
                self.users = fetchedUsers
                self.currentUser = fetchedUsers.first
                print("✅ تم تحديث قائمة المستخدمين! عدد المستخدمين: \(self.users.count)")
            }

        } catch {
            print("❌ خطأ في جلب المستخدمين: \(error.localizedDescription)")
        }
    }
}

//
//  FriendRequest.swift
//  Cashi
//
//  Created by Ghala Alnemari on 10/09/1446 AH.
//
import Foundation
import CloudKit

struct FriendRequest {
    let id: CKRecord.ID
    let senderID: CKRecord.Reference
    let receiverID: CKRecord.Reference
    var status: String

    init?(record: CKRecord) {
        guard let senderID = record["senderID"] as? CKRecord.Reference,
              let receiverID = record["receiverID"] as? CKRecord.Reference,
              let status = record["status"] as? String else { return nil }

        self.id = record.recordID
        self.senderID = senderID
        self.receiverID = receiverID
        self.status = status
    }
}

import Foundation
import CloudKit

class FriendRequestManager {
    
    static let shared = FriendRequestManager()
    let container = CKContainer(identifier: "iCloud.CashiBackup")
    lazy var database = container.publicCloudDatabase
    private init() {}

    // إرسال طلب صداقة
    func sendFriendRequest(to receiver: User, from currentUser: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let record = CKRecord(recordType: "FriendRequest")
        record["senderID"] = CKRecord.Reference(recordID: currentUser.id, action: .none)
        record["receiverID"] = CKRecord.Reference(recordID: receiver.id, action: .none)
        record["status"] = "waiting"

        database.save(record) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    // البحث عن المستخدمين
    func searchUsers(by name: String, completion: @escaping ([User]) -> Void) {
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
            let query = CKQuery(recordType: "ADDUsers", predicate: predicate)

            database.perform(query, inZoneWith: nil) { records, error in
                DispatchQueue.main.async {
                    if let records = records {
                        let users = records.compactMap { User(record: $0) }
                        completion(users)
                    } else {
                        completion([])
                }
            }
        }
    }



    func fetchIncomingFriendRequests(for currentUser: User, completion: @escaping ([FriendRequest]) -> Void) {
            let predicate = NSPredicate(format: "receiverID == %@", currentUser.id) // ✅ الصيغة الصحيحة
            let query = CKQuery(recordType: "FriendRequest", predicate: predicate)

            database.perform(query, inZoneWith: nil) { records, error in
                DispatchQueue.main.async {
                    if let records = records {
                        let requests = records.compactMap { FriendRequest(record: $0) }
                        print("📥 تم جلب \(requests.count) طلبات صداقة واردة")
                        completion(requests)
                    } else {
                        print("❌ لم يتم جلب الطلبات الواردة: \(error?.localizedDescription ?? "خطأ غير معروف")")
                        completion([])
                    }
                }
            }
        }

        // تحديث حالة الطلب (قبول أو رفض)
        func updateFriendRequestStatus(_ request: FriendRequest, newStatus: String, completion: @escaping (Result<Void, Error>) -> Void) {
            database.fetch(withRecordID: request.id) { record, error in
                if let record = record {
                    record["status"] = newStatus
                    self.database.save(record) { _, error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            if newStatus == "accepted" {
                                // ربط المستخدمين كأصدقاء
                                self.addFriendReferencesBetween(senderRef: request.senderID, receiverRef: request.receiverID) {
                                    completion(.success(()))
                                }
                            } else {
                                completion(.success(()))
                            }
                        }
                    }
                } else {
                    completion(.failure(error ?? NSError(domain: "FetchError", code: -1)))
                }
            }
        }

        // إضافة كل طرف لقائمة أصدقاء الآخر
        func addFriendReferencesBetween(senderRef: CKRecord.Reference, receiverRef: CKRecord.Reference, completion: @escaping () -> Void) {
            let group = DispatchGroup()

            // تحديث سجل المرسل
            group.enter()
            database.fetch(withRecordID: senderRef.recordID) { senderRecord, error in
                if let senderRecord = senderRecord {
                    var currentFriends = senderRecord["friends"] as? [CKRecord.Reference] ?? []
                    if !currentFriends.contains(where: { $0.recordID == receiverRef.recordID }) {
                        currentFriends.append(receiverRef)
                        senderRecord["friends"] = currentFriends
                        self.database.save(senderRecord) { _, _ in group.leave() }
                    } else {
                        group.leave()
                    }
                } else {
                    group.leave()
                }
            }

            // تحديث سجل المستقبل
            group.enter()
            database.fetch(withRecordID: receiverRef.recordID) { receiverRecord, error in
                if let receiverRecord = receiverRecord {
                    var currentFriends = receiverRecord["friends"] as? [CKRecord.Reference] ?? []
                    if !currentFriends.contains(where: { $0.recordID == senderRef.recordID }) {
                        currentFriends.append(senderRef)
                        receiverRecord["friends"] = currentFriends
                        self.database.save(receiverRecord) { _, _ in group.leave() }
                    } else {
                        group.leave()
                    }
                } else {
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                completion()
            }
        }
    }

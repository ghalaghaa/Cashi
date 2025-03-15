//
//  ChallengeJoinRequest.swift
//  Cashi
//
//  Created by Shahad Abdulmohsen on 15/09/1446 AH.
//
//
//  ChallengeJoinRequest.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
//

import Foundation
import CloudKit

// MARK: - Model
struct ChallengeJoinRequest: Identifiable {
    let id: CKRecord.ID
    let challengeName: String
    let senderID: CKRecord.Reference
    let receiverID: CKRecord.Reference
    var status: String
    let createdTimestamp: Date
}

// MARK: - Manager
class ChallengeJoinRequestManager {
    static let shared = ChallengeJoinRequestManager()
    private let database = CKContainer.default().privateCloudDatabase

    // MARK: إرسال طلب انضمام للتحدي
    func sendRequest(challengeName: String,
                     senderID: CKRecord.Reference,
                     receiverID: CKRecord.Reference,
                     completion: @escaping (Result<Void, Error>) -> Void) {
        let record = CKRecord(recordType: "ChallengeJoinRequest")
        record["challengeName"] = challengeName
        record["senderID"] = senderID
        record["receiverID"] = receiverID
        record["status"] = "waiting"
        record["createdTimestamp"] = Date()

        database.save(record) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Failed to send challenge request: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("✅ Challenge request sent successfully")
                    completion(.success(()))
                }
            }
        }
    }

    // MARK: جلب الطلبات الواردة للمستخدم الحالي
    func fetchIncomingRequests(for currentUserRef: CKRecord.Reference,
                               completion: @escaping ([ChallengeJoinRequest]) -> Void) {
        let predicate = NSPredicate(format: "receiverID == %@", currentUserRef)
        let query = CKQuery(recordType: "ChallengeJoinRequest", predicate: predicate)

        database.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                guard let records = records, error == nil else {
                    print("❌ Error fetching challenge requests: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }

                let requests = records.map { record in
                    ChallengeJoinRequest(
                        id: record.recordID,
                        challengeName: record["challengeName"] as? String ?? "",
                        senderID: record["senderID"] as? CKRecord.Reference ?? CKRecord.Reference(recordID: CKRecord.ID(recordName: "Unknown"), action: .none),
                        receiverID: record["receiverID"] as? CKRecord.Reference ?? CKRecord.Reference(recordID: CKRecord.ID(recordName: "Unknown"), action: .none),
                        status: record["status"] as? String ?? "waiting",
                        createdTimestamp: record["createdTimestamp"] as? Date ?? Date()
                    )
                }

                completion(requests)
            }
        }
    }

    // MARK: تحديث حالة الطلب (قبول / رفض)
    func updateRequestStatus(request: ChallengeJoinRequest,
                             newStatus: String,
                             completion: @escaping (Result<Void, Error>) -> Void) {
        database.fetch(withRecordID: request.id) { record, error in
            guard let record = record, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? NSError(domain: "FetchError", code: -1, userInfo: nil)))
                }
                return
            }

            record["status"] = newStatus

            self.database.save(record) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Failed to update status: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("✅ Challenge request status updated to: \(newStatus)")
                        completion(.success(()))
                    }
                }
            }
        }
    }
}


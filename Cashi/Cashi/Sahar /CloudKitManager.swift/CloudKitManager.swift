////
////  CloudKitManager.swift
////  Cashi
////
////  Created by Sahar Otiyn on 15/09/1446 AH.
////
//
//import SwiftUI
//import CloudKit
//
//class CloudKitManager {
//    static let shared = CloudKitManager()
//    let container = CKContainer.default()
//    lazy var publicDatabase = container.publicCloudDatabase
//
//    func fetchRecords(recordType: String, completion: @escaping ([CKRecord]?, Error?) -> Void) {
//        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
//        publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
//            completion(records, error)
//        }
//    }
//
//    func saveRecord(record: CKRecord, completion: @escaping (CKRecord?, Error?) -> Void) {
//        publicDatabase.save(record) { (savedRecord, error) in
//            completion(savedRecord, error)
//        }
//    }
//}
//import CloudKit
//
//class CloudKitManager {
//    static let shared = CloudKitManager()
//    let container = CKContainer.default()
//    let publicDatabase: CKDatabase
//
//    private init() {
//        publicDatabase = container.publicCloudDatabase
//    }
//
//    func saveFriend(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        let record = CKRecord(recordType: "Friend")
//        record["name"] = name as CKRecordValue
//
//        publicDatabase.save(record) { savedRecord, error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//
//    func fetchFriends(completion: @escaping (Result<[Friend], Error>) -> Void) {
//        let query = CKQuery(recordType: "Friend", predicate: NSPredicate(value: true))
//
//        publicDatabase.perform(query, inZoneWith: nil) { records, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let records = records else {
//                completion(.success([]))
//                return
//            }
//
//            let friends = records.compactMap { record -> Friend? in
//                guard let name = record["name"] as? String else { return nil }
//                return Friend(name: name, recordID: record.recordID)
//            }
//            completion(.success(friends))
//        }
//    }
//
//    func saveChallengeRequest(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        let record = CKRecord(recordType: "ChallengeRequest")
//        record["name"] = name as CKRecordValue
//
//        publicDatabase.save(record) { savedRecord, error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//
//    func fetchChallengeRequests(completion: @escaping (Result<[ChallengeRequest], Error>) -> Void) {
//        let query = CKQuery(recordType: "ChallengeRequest", predicate: NSPredicate(value: true))
//
//        publicDatabase.perform(query, inZoneWith: nil) { records, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let records = records else {
//                completion(.success([]))
//                return
//            }
//
//            let challengeRequests = records.compactMap { record -> ChallengeRequest? in
//                guard let name = record["name"] as? String else { return nil }
//                return ChallengeRequest(name: name, recordID: record.recordID)
//            }
//            completion(.success(challengeRequests))
//        }
//    }
//}

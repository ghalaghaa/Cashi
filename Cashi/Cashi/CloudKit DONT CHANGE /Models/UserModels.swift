//
//  ContentView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
//
import SwiftUI
import CloudKit



struct User {
    let id: CKRecord.ID
    let name: String
    let email: String
    let show: [CKRecord.Reference]?
    let salary: Double

    init?(record: CKRecord) {
        guard let name = record["name"] as? String,
              let email = record["email"] as? String,
              let salary = record["income"] as? String,
              let salaryDouble = Double(salary) else {
            print("⚠️ Missing or invalid fields in User record: \(record)")
            return nil
        }

        self.id = record.recordID
        self.name = name
        self.email = email
        self.show = record["show"] as? [CKRecord.Reference]
        self.salary = salaryDouble
    }
}

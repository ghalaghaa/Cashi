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

    init?(record: CKRecord) {
        guard let name = record["name"] as? String,
              let email = record["email"] as? String else { return nil }

        self.id = record.recordID
        self.name = name
        self.email = email
    }
}

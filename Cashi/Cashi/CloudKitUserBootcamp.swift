//
//  CloudKitUserBootcamp.swift
//  Cashi
//
//  Created by Ghala Alnemari on 27/08/1446 AH.
//
//

import SwiftUI
import CloudKit

struct CloudKitUserBootcamp: View {
    @StateObject private var vm = CloudKitUserBootcampViewModel()  // ✅ تأكد من أن الاسم صحيح

    var body: some View {
        VStack(spacing: 20) {
            Text("هل المستخدم مسجل في iCloud؟")
                .font(.headline)

            Text(vm.isSignedInToiCloud ? "✅ نعم" : "❌ لا")
                .font(.title)
                .foregroundColor(vm.isSignedInToiCloud ? .green : .red)

            if !vm.error.isEmpty {
                Text("⚠️ خطأ: \(vm.error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("name: \(vm.userName)")
            }
        }
        .padding()
    }
}

struct CloudKitUserBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitUserBootcamp()
    }
}




class CloudKitUserBootcampViewModel: ObservableObject {
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    
    init() {
        getiCloudStatus()
        fetchiCloudUserRecordID()
    }
    
    private func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                switch returnedStatus {
                case .available:
                    self?.isSignedInToiCloud = true
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccountNotFound.rawValue
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.rawValue
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.rawValue
                default:
                    self?.error = CloudKitError.iCloudAccountUnknown.rawValue
                }
            }
        }
    }
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotFound = "لم يتم العثور على حساب iCloud"
        case iCloudAccountNotDetermined = "تعذر تحديد حالة حساب iCloud"
        case iCloudAccountRestricted = "حساب iCloud مقيد"
        case iCloudAccountUnknown = "حالة حساب iCloud غير معروفة"
    }
    
    func fetchiCloudUserRecordID() {
        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID {
                self?.discoveriCloudUser (id: id)
                
            }
        }
    }
    func discoveriCloudUser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    self?.userName = name
                }
            }
        }
    }
}

//
//
//import SwiftUI
//import CloudKit
//
//class CloudKitUserBootcampViewModel: ObservableObject {
//    @Published var isSignedInToiCloud: Bool = false
//    @Published var error: String = ""
//
//    init() {
//        getiCloudStatus()
//    }
//
//    private func getiCloudStatus() {
//        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in
//            DispatchQueue.main.async {
//                switch returnedStatus {
//                case .available:
//                    self?.isSignedInToiCloud = true
//                case .noAccount:
//                    self?.error = CloudKitError.iCloudAccountNotFound.rawValue
//                case .couldNotDetermine:
//                    self?.error = CloudKitError.iCloudAccountNotDetermined.rawValue
//                case .restricted:
//                    self?.error = CloudKitError.iCloudAccountRestricted.rawValue
//                default:
//                    self?.error = CloudKitError.iCloudAccountUnknown.rawValue
//                }
//            }
//        }
//    }
//
//    enum CloudKitError: String, LocalizedError {
//        case iCloudAccountNotFound = "لم يتم العثور على حساب iCloud"
//        case iCloudAccountNotDetermined = "تعذر تحديد حالة حساب iCloud"
//        case iCloudAccountRestricted = "حساب iCloud مقيد"
//        case iCloudAccountUnknown = "حالة حساب iCloud غير معروفة"
//    }
//}
//

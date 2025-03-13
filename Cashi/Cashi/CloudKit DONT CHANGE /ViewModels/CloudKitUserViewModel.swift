
import SwiftUI
import CloudKit


class CloudKitUserViewModel: ObservableObject {
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    @Published var users: [User] = []
    @Published var currentUser: User?
    @Published var friends: [User] = []

    private let container = CKContainer(identifier: "iCloud.CashiBackup")
    private let database: CKDatabase

    init() {
        self.database = container.publicCloudDatabase
        getiCloudStatus()
        fetchiCloudUserRecordID()
    }

    private func getiCloudStatus() {
        container.accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                switch status {
                case .available:
                    self?.isSignedInToiCloud = true
                case .noAccount:
                    self?.error = "لا يوجد حساب iCloud"
                case .restricted:
                    self?.error = "حساب iCloud مقيد"
                case .couldNotDetermine:
                    self?.error = "تعذر تحديد حالة حساب iCloud"
                default:
                    self?.error = "حالة iCloud غير معروفة"
                }
            }
        }
    }

    func fetchiCloudUserRecordID() {
        container.fetchUserRecordID { [weak self] id, error in
            if let id = id {
                self?.discoveriCloudUser(id: id)
            }
        }
    }

    func discoveriCloudUser(id: CKRecord.ID) {
        container.discoverUserIdentity(withUserRecordID: id) { [weak self] identity, error in
            DispatchQueue.main.async {
                if let name = identity?.nameComponents?.givenName {
                    self?.userName = name
                }
            }
        }
    }

    func addUser(name: String, email: String) async throws {
        let record = CKRecord(recordType: "ADDUsers")
        record["name"] = name as CKRecordValue
        record["email"] = email as CKRecordValue
        record["friends"] = [] as CKRecordValue

        try await database.save(record)

        // حفظ recordID للمستخدم الجديد
        UserDefaults.standard.set(record.recordID.recordName, forKey: "currentUserRecordID")
    }

    func fetchUsers() async throws {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ADDUsers", predicate: predicate)

        do {
            let (results, _) = try await database.records(matching: query)

            let fetchedUsers = results.compactMap { _, result -> User? in
                switch result {
                case .success(let record):
                    return User(record: record)
                case .failure:
                    return nil
                }
            }

            DispatchQueue.main.async {
                self.users = fetchedUsers

                // تعيين currentUser بناءً على recordID المحفوظ
                let savedID = UserDefaults.standard.string(forKey: "currentUserRecordID")
                self.currentUser = fetchedUsers.first(where: { $0.id.recordName == savedID })

                if let current = self.currentUser {
                    Task {
                        await self.fetchFriends(for: current)
                    }
                }
            }

        } catch {
            print("❌ فشل في تحميل المستخدمين: \(error.localizedDescription)")
        }
    }

    func fetchFriends(for user: User) async {
        do {
            let record = try await database.record(for: user.id)
            guard let refs = record["friends"] as? [CKRecord.Reference] else { return }

            let result = try await database.records(for: refs.map { $0.recordID })

            let friends = result.compactMap {
                try? $0.value.get()
            }.compactMap {
                User(record: $0)
            }

            DispatchQueue.main.async {
                self.friends = friends
            }

        } catch {
            print("❌ فشل في جلب الأصدقاء: \(error.localizedDescription)")
        }
    }
    func fetchUserRecord(by recordID: CKRecord.ID) async throws -> CKRecord {
        return try await database.record(for: recordID)
    }

    func assignCurrentUser(by email: String) {
        if let foundUser = users.first(where: { $0.email.lowercased() == email.lowercased() }) {
            self.currentUser = foundUser
            UserDefaults.standard.set(foundUser.id.recordName, forKey: "currentUserRecordID")
            print("✅ تم تعيين currentUser من خلال الإيميل: \(foundUser.email)")
            Task {
                await fetchFriends(for: foundUser)
            }
        } else {
            print("❌ المستخدم غير موجود")
        }
    }
}

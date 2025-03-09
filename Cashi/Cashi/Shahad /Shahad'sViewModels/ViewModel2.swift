import SwiftUI
import CloudKit

class ViewModel2: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var calculations: [Calculation] = [] // Retrieved calculations
    @Published var error: String?
    @Published var user: User?
    
    private let container = CKContainer(identifier: "iCloud.CashiBackup")
    private let database: CKDatabase
    
    init(user: User?) {
        self.database = container.publicCloudDatabase
        self.user = user
        Task {
            await fetchGoals()       // Fetch goals
            await fetchCalculations() // Fetch stored calculations
        }
    }
    
    // MARK: - جلب المستخدمين ✅
    func fetchUsers() async throws {
        let query = CKQuery(recordType: "User", predicate: NSPredicate(value: true))
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            DispatchQueue.main.async {
                if let record = results.first {
                    self.user = User(record: record)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to fetch user: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - جلب الأهداف ✅
    func fetchGoals() async {
        let query = CKQuery(recordType: "Goal", predicate: NSPredicate(value: true))
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            DispatchQueue.main.async {
                self.goals = results.map { Goal(record: $0) }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to fetch goals: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - حساب مدة الوصول إلى الهدف ✅
    func calculateDuration(cost: Double, salary: Double, savingsPerPeriod: Double) -> Int {
        guard savingsPerPeriod > 0 else { return 0 }
        return Int(ceil(cost / savingsPerPeriod))
    }

    // MARK: - جلب الحسابات السابقة ✅
    func fetchCalculations() async {
        let query = CKQuery(recordType: "Calculations", predicate: NSPredicate(value: true))
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            DispatchQueue.main.async {
                self.calculations = results.map { Calculation(record: $0) }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to fetch calculations: \(error.localizedDescription)"
            }
        }
    }
    // ✅ تحديث الحسابات في iCloud
    func updateCalculation(calculation: Calculation) async {
        let query = CKQuery(recordType: "Calculations", predicate: NSPredicate(format: "goalName == %@", calculation.goalName))
        
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            
            if let record = results.first {
                record["salary"] = calculation.salary as CKRecordValue
                
                try await database.save(record)
                print("✅ تم تحديث الحساب بنجاح")
                
                DispatchQueue.main.async {
                    if let index = self.calculations.firstIndex(where: { $0.goalName == calculation.goalName }) {
                        self.calculations[index] = calculation
                    }
                }
            }
        } catch {
            print("⚠️ Failed to update calculation: \(error.localizedDescription)")
        }
    }
    // MARK: - حفظ الحسابات في iCloud ✅
    func saveCalculation(goal: Goal, cost: Double, salary: Double, savingsType: Goal.SavingsType, savingsRequired: Double) async {
        let record = CKRecord(recordType: "Calculations")
        record["goalName"] = goal.name as CKRecordValue
        record["cost"] = cost as CKRecordValue
        record["salary"] = salary as CKRecordValue
        record["savingsType"] = savingsType.rawValue as CKRecordValue
        record["savingsRequired"] = savingsRequired as CKRecordValue
        record["emoji"] = goal.emoji as CKRecordValue
        
        do {
            try await database.save(record)
            print("✅ تم حفظ الحساب بنجاح")
            DispatchQueue.main.async {
                self.calculations.append(Calculation(record: record))
            }
        } catch {
            print("⚠️ Failed to save calculation: \(error.localizedDescription)")
        }
    }

    // MARK: - 🔹 **حفظ هدف جديد في iCloud** ✅
    func saveGoal(goal: Goal) async {
        let record = goal.toCKRecord()
        do {
            try await database.save(record)
            print("✅ تم حفظ الهدف بنجاح")
            DispatchQueue.main.async {
                self.goals.append(goal)
            }
        } catch {
            print("⚠️ Failed to save goal: \(error.localizedDescription)")
        }
    }

    // MARK: - 🔹 **تحديث هدف موجود في iCloud** ✅
    func updateGoal(goal: Goal) async {
        let recordID = goal.id
        do {
            let record = try await database.record(for: recordID)
            
            // تحديث البيانات في iCloud
            record["name"] = goal.name as CKRecordValue
            record["cost"] = goal.cost as CKRecordValue
            record["salary"] = goal.salary as CKRecordValue
            record["savingsType"] = goal.savingsType.rawValue as CKRecordValue
            record["emoji"] = goal.emoji as CKRecordValue
            
            if let imageData = goal.imageData {
                let asset = CKAsset(fileURL: saveImageToTemporaryURL(data: imageData))
                record["image"] = asset
            }
            
            try await database.save(record)
            print("✅ تم تحديث الهدف بنجاح")
            
            // تحديث القائمة في الواجهة
            DispatchQueue.main.async {
                if let index = self.goals.firstIndex(where: { $0.id == goal.id }) {
                    self.goals[index] = goal
                }
            }
        } catch {
            print("⚠️ Failed to update goal: \(error.localizedDescription)")
        }
    }

    // MARK: - 🔹 **حفظ صورة إلى مسار مؤقت لـ CKAsset** ✅
    private func saveImageToTemporaryURL(data: Data) -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        do {
            try data.write(to: fileURL)
        } catch {
            print("⚠️ Failed to save image: \(error.localizedDescription)")
        }
        return fileURL
    }
}

// MARK: - نموذج الحساب (Calculation)
struct Calculation {
    let id: CKRecord.ID
    let goalName: String
    let cost: Double
    var salary: Double // ✅ جعله متغيرًا حتى نتمكن من تعديله
    let savingsType: Goal.SavingsType
    let savingsRequired: Double
    let emoji: String

    // ✅ مهيئ لتحميل البيانات من CloudKit
    init(record: CKRecord) {
        self.id = record.recordID
        self.goalName = record["goalName"] as? String ?? ""
        self.cost = record["cost"] as? Double ?? 0.0
        self.salary = record["salary"] as? Double ?? 0.0
        self.savingsType = Goal.SavingsType(rawValue: record["savingsType"] as? String ?? "Monthly") ?? .monthly
        self.savingsRequired = record["savingsRequired"] as? Double ?? 0.0
        self.emoji = record["emoji"] as? String ?? "🎯"
    }

    // ✅ مهيئ مخصص لإنشاء نسخة جديدة بدون الحاجة إلى `CKRecord`
    init(id: CKRecord.ID, goalName: String, cost: Double, salary: Double, savingsType: Goal.SavingsType, savingsRequired: Double, emoji: String) {
        self.id = id
        self.goalName = goalName
        self.cost = cost
        self.salary = salary
        self.savingsType = savingsType
        self.savingsRequired = savingsRequired
        self.emoji = emoji
    }
}

extension ViewModel2 {
    func checkCloudKitStatus() async {
        let container = CKContainer(identifier: "iCloud.CashiBackup")

        do {
            let status = try await container.accountStatus()
            DispatchQueue.main.async {
                switch status {
                case .available:
                    print("✅ حساب CloudKit متاح.")
                case .noAccount:
                    print("❌ لا يوجد حساب iCloud متصل بالجهاز.")
                case .restricted:
                    print("❌ الوصول إلى iCloud مقيد.")
                case .couldNotDetermine:
                    print("❌ لا يمكن تحديد حالة الحساب.")
                case .temporarilyUnavailable:
                    print("⚠️ حساب iCloud غير متاح مؤقتًا.")
                @unknown default:
                    print("❌ حالة غير معروفة لحساب iCloud.")
                }
            }
        } catch {
            print("❌ خطأ أثناء جلب حالة الحساب: \(error.localizedDescription)")
        }
    }
    func deleteCalculation(calculation: Calculation) async {
        let recordID = calculation.id
        let database = container.publicCloudDatabase

        do {
            // أولاً، جلب السجل للتأكد من وجوده
            let record = try await database.record(for: recordID)
            try await database.deleteRecord(withID: record.recordID)

            DispatchQueue.main.async {
                self.calculations.removeAll { $0.id == calculation.id }
                print("✅ تم حذف الحساب بنجاح من CloudKit والواجهة.")
            }
        } catch {
            DispatchQueue.main.async {
                print("⚠️ فشل حذف الحساب: \(error.localizedDescription)")
            }
        }
    }
}

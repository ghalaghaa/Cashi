import SwiftUI
import CloudKit
import Foundation

class ViewModel2: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var calculations: [Calculation] = []
    @Published var error: String?
    @Published var user: User?
    @Published var qattahGoals: [Goal] = []
    @Published var challengeGoals: [Goal] = []
    @Published var individualGoals: [Goal] = []


    private let container = CKContainer(identifier: "iCloud.CashiBackup")
    private let database: CKDatabase

    init(user: User?) {
        self.database = container.publicCloudDatabase
        self.user = user
        Task {
            await fetchUsers()
            await fetchGoals()
            await fetchCalculations()
            await fetchQattahGoals()
            await fetchIndividualGoals()
            await fetchChallengeGoals()


        }
    }
    
    func getGoalName(for goalType: Goal.GoalType) -> String {
        switch goalType {
        case .individual:
            return "Individual Goal"
        case .qattah:
            return "Qattah Goal"
        case .challenge:
            return "Challenge Goal"
        }
    }

    // مثال على جلب الأهداف (سيتم استخدام getGoalName هنا)
    func fetchQattahGoals() async {
        let predicate = NSPredicate(format: "goalType == %@", Goal.GoalType.qattah.rawValue)
        let query = CKQuery(recordType: "Goal", predicate: predicate)
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            let newGoals = results.compactMap { Goal(record: $0) }
            DispatchQueue.main.async {
                self.qattahGoals = newGoals
                print("✅ Successfully fetched \(newGoals.count) qattah goals.")
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to fetch qattah goals: \(error.localizedDescription)"
                print(self.error!)
            }
        }
    }
    
    
    
    func fetchIndividualGoals() async {
        let predicate = NSPredicate(format: "goalType == %@", Goal.GoalType.individual.rawValue)
        let query = CKQuery(recordType: "Goal", predicate: predicate)
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            let newGoals = results.compactMap { Goal(record: $0) }
            DispatchQueue.main.async {
                self.goals = newGoals
                print("✅ Successfully fetched \(newGoals.count) individual goals.")
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to fetch individual goals: \(error.localizedDescription)"
                print(self.error!)
            }
        }
    }

    func fetchChallengeGoals() async {
        let predicate = NSPredicate(format: "goalType == %@", Goal.GoalType.challenge.rawValue)
        let query = CKQuery(recordType: "Goal", predicate: predicate)
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            let newGoals = results.compactMap { Goal(record: $0) }
            DispatchQueue.main.async {
                self.challengeGoals = newGoals
                print("✅ Successfully fetched \(newGoals.count) challenge goals.")
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to fetch challenge goals: \(error.localizedDescription)"
                print(self.error!)
            }
        }
    }

    // هل `updateCalculation` مفقودة هنا؟ إذا لم تكن موجودة، أضفها:
    func updateCalculation(calculation: Calculation) async {
        do {
            let record = try await database.record(for: calculation.id)
            record["salary"] = calculation.salary as CKRecordValue

            try await database.save(record)
            print("✅ Calculation updated successfully")
        } catch {
            print("❌ Error updating calculation: \(error.localizedDescription)")
        }
    }
    // MARK: - 🔹 Fetch Users (Updated)
    func fetchUsers() async {
        let query = CKQuery(recordType: "User", predicate: NSPredicate(value: true))

        do {
            let results = try await database.perform(query, inZoneWith: nil)
            DispatchQueue.main.async {
                if results.isEmpty {
                    print("⚠️ No 'User' records found in CloudKit. Ensure you have at least one User record.")
                    self.user = nil
                } else {
                    print("✅ Found \(results.count) user records: \(results)")
                    if let firstRecord = results.first, let user = User(record: firstRecord) {
                        self.user = user
                        print("✅ User fetched successfully: \(user.name)")
                    } else {
                        print("⚠️ Found user record but missing required fields: \(results.first!)")
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to fetch user: \(error.localizedDescription)"
                print("❌ Error fetching users: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - 🔹 Fetch Goals
    func fetchGoals() async {
        let query = CKQuery(recordType: "Goal", predicate: NSPredicate(value: true))
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            let newGoals = results.compactMap { Goal(record: $0) }
            DispatchQueue.main.async {
                self.goals = newGoals
                print("✅ Successfully fetched \(newGoals.count) goals.")
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to fetch goals: \(error.localizedDescription)"
                print(self.error!)
            }
        }
    }

    // MARK: - 🔹 Fetch Calculations
    func fetchCalculations() async {
        let query = CKQuery(recordType: "Calculations", predicate: NSPredicate(value: true))
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            let newCalculations = results.compactMap { Calculation(record: $0) }
            DispatchQueue.main.async {
                self.calculations = newCalculations
                print("✅ Successfully fetched \(newCalculations.count) calculations.")
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to fetch calculations: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - 🔹 Save Goal
    func saveGoal(goal: Goal) async -> Bool {
        let record = CKRecord(recordType: "Goal", recordID: goal.id)

        record["name"] = goal.name as CKRecordValue
        record["cost"] = goal.cost as CKRecordValue
        record["salary"] = goal.salary as CKRecordValue
        record["savingsType"] = goal.savingsType.rawValue as CKRecordValue
        record["emoji"] = goal.emoji as CKRecordValue
        record["goalType"] = goal.goalType.rawValue as CKRecordValue

        if let imageData = goal.imageData, let fileURL = saveImageToTemporaryURL(data: imageData) {
            record["imageData"] = CKAsset(fileURL: fileURL)
        }

        do {
            try await database.save(record)
            print("✅ Goal saved successfully: \(goal.name)")
            return true
        } catch {
            print("⚠️ Failed to save goal: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - 🔹 Save Calculation
    func saveCalculation(goal: Goal, cost: Double?, salary: Double?, savingsType: Goal.SavingsType?, savingsRequired: Double, completion: ((Bool) -> Void)? = nil) async {
        let safeCost = cost ?? 0.0
        let safeSalary = salary ?? 0.0
        let validSavingsType = savingsType ?? .monthly

        let record = CKRecord(recordType: "Calculations")
        record["goalName"] = goal.name as CKRecordValue
        record["cost"] = NSNumber(value: safeCost)
        record["salary"] = NSNumber(value: safeSalary)
        record["savingsType"] = validSavingsType.rawValue as CKRecordValue
        record["savingsRequired"] = NSNumber(value: savingsRequired)
        record["emoji"] = goal.emoji as CKRecordValue

        do {
            try await database.save(record)
            DispatchQueue.main.async {
                if let calculation = Calculation(record: record) {
                    self.calculations.append(calculation)
                    print("✅ Calculation saved successfully: \(goal.name)")
                    completion?(true)
                } else {
                    print("⚠️ Failed to convert saved record to Calculation")
                    completion?(false)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to save calculation: \(error.localizedDescription)"
                completion?(false)
            }
        }
    }
    

    // MARK: - 🔹 Update Goal
    func updateGoal(goal: Goal) async {
        do {
            let record = try await database.record(for: goal.id)
            record["name"] = goal.name as CKRecordValue
            record["cost"] = goal.cost as CKRecordValue
            record["salary"] = goal.salary as CKRecordValue
            record["savingsType"] = goal.savingsType.rawValue as CKRecordValue
            record["emoji"] = goal.emoji as CKRecordValue
            record["goalType"] = goal.goalType.rawValue as CKRecordValue

            if let newImageData = goal.imageData, let fileURL = saveImageToTemporaryURL(data: newImageData) {
                record["imageData"] = CKAsset(fileURL: fileURL)
            }

            try await database.save(record)
            DispatchQueue.main.async {
                if let index = self.goals.firstIndex(where: { $0.id == goal.id }) {
                    self.goals[index] = goal
                }
                print("✅ Goal updated successfully: \(goal.name)")
            }
        } catch {
            DispatchQueue.main.async {
                print("❌ ERROR: Failed to update goal \(goal.name) - \(error.localizedDescription)")
            }
        }
    }

    // MARK: - 🔹 Save Image to Temporary URL
    private func saveImageToTemporaryURL(data: Data) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")

        do {
            try data.write(to: fileURL, options: .atomic)
            return fileURL
        } catch {
            print("⚠️ Failed to save image: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - 🔹 Check Record Types in CloudKit (Debugging)
    func fetchAllRecordTypes() async {
        let query = CKQuery(recordType: "User", predicate: NSPredicate(value: true))
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            print("✅ Found \(results.count) User records in CloudKit.")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
}

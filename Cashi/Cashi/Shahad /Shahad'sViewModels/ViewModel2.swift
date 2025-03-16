import SwiftUI
import CloudKit
import Foundation

class ViewModel2: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var calculations: [Calculation] = []
    @Published var error: String?
    @Published var user: User?
    @Published var users: [User] = [] // ✅ Fix for `users`
    @Published var qattahGoals: [Goal] = []
    @Published var challengeGoals: [Goal] = []
    @Published var individualGoals: [Goal] = []
    
    private let container = CKContainer(identifier: "iCloud.CashiBackup")
    private let database: CKDatabase
    
    init(user: User?) {
        self.database = container.publicCloudDatabase
        self.user = user
        Task {
            do {
                try await fetchUsers() // ✅ Added `try` with error handling
            } catch {
                print("❌ Error fetching users: \(error.localizedDescription)")
            }
            await fetchGoals()
            await fetchCalculations()
            await fetchQattahGoals()
            //            await fetchIndividualGoals()
            await fetchChallengeGoals()
        }
    }
    
    func fetchUsers() async {
        let query = CKQuery(recordType: "ADDUsers", predicate: NSPredicate(value: true))
        
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            let fetchedUsers = results.compactMap { User(record: $0) }
            
            DispatchQueue.main.async {
                self.user = fetchedUsers.first
                print("✅ Fetched \(fetchedUsers.count) users")
            }
        } catch {
            print("❌ Error fetching users: \(error.localizedDescription)")
        }
    }
    
    func fetchGoals() async {
        let query = CKQuery(recordType: "Goal", predicate: NSPredicate(value: true))
        do {
            let results = try await database.perform(query, inZoneWith: nil)
            let newGoals = results.compactMap { Goal(record: $0) }
            
            DispatchQueue.main.async {
                self.goals = newGoals
                self.qattahGoals = newGoals.filter { $0.goalType == .qattah }
                self.challengeGoals = newGoals.filter { $0.goalType == .challenge }
                self.individualGoals = newGoals.filter { $0.goalType == .individual }
            }
            
            print("✅ Successfully fetched \(newGoals.count) goals.")
        } catch {
            DispatchQueue.main.async {
                self.error = "⚠️ Failed to fetch goals: \(error.localizedDescription)"
            }
            print(self.error!)
        }
    }
    func calculateSavingsForGoal(goal: Goal, savingRate: Double) -> (savingsPerMonth: Double, duration: Int) {
        guard goal.cost > 0, savingRate > 0 else { return (0, 0) }
        
        let costPerPerson: Double
        if goal.goalType == .qattah, let participants = goal.participants {
            costPerPerson = goal.cost / Double(participants) // ✅ تقسيم التكلفة على عدد المشاركين
        } else {
            costPerPerson = goal.cost
        }
        
        let savingsPerMonth = costPerPerson * savingRate // ✅ يتم تحديد نسبة التوفير من قبل المستخدم
        let duration = Int(ceil(costPerPerson / savingsPerMonth))
        
        return (savingsPerMonth, max(1, duration)) // ✅ تجنب القيم السالبة أو 0
    }
    
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
            }
        }
    }
    
//        func fetchIndividualGoals() async {
//            var onAddGoal: () -> Void
//            @Binding var selectedGoal: Goal?
//           @Binding var selectedGoals: [Goal]
//           @Binding var isSelectingGoals: Bool
//            
//            let predicate = NSPredicate(format: "goalType == %@", Goal.GoalType.individual.rawValue)
//            let query = CKQuery(recordType: "Goal", predicate: predicate)
//            do {
//                let results = try await database.perform(query, inZoneWith: nil)
//                let newGoals = results.compactMap { Goal(record: $0) }
//                DispatchQueue.main.async {
//                    self.goals = newGoals
//                    print("✅ Successfully fetched \(newGoals.count) individual goals.")
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.error = "⚠️ Failed to fetch individual goals: \(error.localizedDescription)"
//                    print(self.error!)
//                }
//            }
//        }
    
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
    
    func updateCalculationProgress(calculation: Calculation, increase: Bool) async {
        do {
            let record = try await database.record(for: calculation.id)
            let currentSalary = record["salary"] as? Double ?? 0.0
            let newSalary = increase ? currentSalary + 10 : max(0, currentSalary - 10)
            
            record["salary"] = newSalary as CKRecordValue
            
            try await database.save(record)
            print("✅ Calculation progress updated successfully")
            
            await fetchCalculations()
        } catch {
            print("❌ Error updating calculation progress: \(error.localizedDescription)")
        }
    }
    
    func updateGoalCollectedAmount(goal: Goal, increase: Bool) async {
        do {
            print("🚀 Updating collected amount for goal: \(goal.name)")
            
            let record = try await database.record(for: goal.id)
            let currentCollectedAmount = record["collectedAmount"] as? Double ?? 0.0
            let newCollectedAmount = increase ? currentCollectedAmount + 100 : max(0, currentCollectedAmount - 100)
            
            record["collectedAmount"] = newCollectedAmount as CKRecordValue
            
            try await database.save(record)
            print("✅ Goal collected amount updated successfully.")
            
            // ✅ Update local state
            DispatchQueue.main.async {
                if let index = self.goals.firstIndex(where: { $0.id == goal.id }) {
                    self.goals[index].collectedAmount = newCollectedAmount
                }
            }
        } catch {
            print("❌ Error updating goal collected amount: \(error.localizedDescription)")
        }
    }
    
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
    
    func saveGoal(goal: Goal) async -> Bool {
        let record = CKRecord(recordType: "Goal", recordID: goal.id)

        record["name"] = goal.name as CKRecordValue
        record["cost"] = goal.cost as CKRecordValue
        record["salary"] = goal.salary as CKRecordValue
        record["savingsType"] = goal.savingsType.rawValue as CKRecordValue
        record["emoji"] = goal.emoji as CKRecordValue
        record["goalType"] = goal.goalType.rawValue as CKRecordValue
        record["isWidgetGoal"] = goal.isWidgetGoal ? "true" : "false"

        if goal.goalType == .qattah, let participants = goal.participants {
            record["participants"] = participants as CKRecordValue
        }
        
        if let imageData = goal.imageData {
               if let asset = createAsset(from: imageData) {
                   record["imageData"] = asset
               }
           }

        return await withCheckedContinuation { continuation in
            let modifyOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            modifyOperation.savePolicy = .changedKeys // ✅ يسمح بالتحديث إذا كان موجود
            modifyOperation.modifyRecordsCompletionBlock = { savedRecords, _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("⚠️ Failed to save goal: \(error.localizedDescription)")
                        continuation.resume(returning: false)
                    } else {
                        print("✅ Goal saved successfully: \(goal.name)")
                        continuation.resume(returning: true)
                    }
                }
            }
            database.add(modifyOperation)
        }
    }
    
    
    
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
    
    func deleteGoal(_ goal: Goal) async -> Bool {
            do {
                // ✅ Delete the goal from CloudKit or local storage
                // Assuming you're using CloudKit:
                let recordID = goal.id
                let database = CKContainer.default().privateCloudDatabase
                try await database.deleteRecord(withID: recordID)
                
                DispatchQueue.main.async {
                    self.goals.removeAll { $0.id == goal.id }
                }
                
                return true // ✅ Successfully deleted
            } catch {
                print("❌ Error deleting goal: \(error.localizedDescription)")
                return false // ❌ Deletion failed
            }
        }
    

    func updateGoal(goal: Goal) async {
        do {
            let record = try await database.record(for: goal.id)
            record["name"] = goal.name as CKRecordValue
            record["cost"] = goal.cost as CKRecordValue
            record["salary"] = goal.salary as CKRecordValue
            record["savingsType"] = goal.savingsType.rawValue as CKRecordValue
            record["emoji"] = goal.emoji as CKRecordValue
            record["goalType"] = goal.goalType.rawValue as CKRecordValue

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
    func setGoalAsWidgetGoal(_ goal: Goal) async {
        do {
            let record = try await database.record(for: goal.id)
            record["isWidgetGoal"] = "true"

            try await database.save(record)

            print("✅ Goal marked as Widget Goal successfully")
        } catch {
            print("❌ Failed to set Widget Goal: \(error.localizedDescription)")
        }
    }
    
    func generateSavingPointsFromGoals(goals: [Goal]) -> [SavingPoint] {
                return goals.map { goal in
                    let date = goal.modifiedDate ?? Date() // استخدم التاريخ من السجل أو الآن إذا لم يكن موجودًا
                    return SavingPoint(date: date, amount: goal.collectedAmount)
                }
            }
        
        func generateGroupedSavingPoints(from goals: [Goal], granularity: Calendar.Component) -> [SavingPoint] {
            let calendar = Calendar.current
            var grouped: [Date: Double] = [:]
            
            for goal in goals {
                let date = goal.modifiedDate ?? Date()
                let components = calendar.dateComponents([granularity], from: date)
                if let groupedDate = calendar.date(from: components) {
                    grouped[groupedDate, default: 0.0] += goal.collectedAmount
                }
            }
            
            return grouped.map { SavingPoint(date: $0.key, amount: $0.value) }
        }
    func resetAllWidgetGoals(except goalID: CKRecord.ID) async {
        for index in self.goals.indices {
            if self.goals[index].id != goalID {
                self.goals[index].isWidgetGoal = false
            }
        }

        let recordsToUpdate = goals.filter { $0.id != goalID }.map { goal -> CKRecord in
            let record = CKRecord(recordType: "Goal", recordID: goal.id)
            record["isWidgetGoal"] = "false" as CKRecordValue
            return record
        }

        do {
            for record in recordsToUpdate {
                try await database.save(record)
            }
            print("✅ Reset all other widget goals.")
        } catch {
            print("❌ Failed to reset widget goals: \(error.localizedDescription)")
        }
    }
    
    func createAsset(from data: Data) -> CKAsset? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        do {
            try data.write(to: fileURL, options: .atomic)
            return CKAsset(fileURL: fileURL)
        } catch {
            print("❌ Failed to create CKAsset: \(error.localizedDescription)")
            return nil
        }
    }

}

//
//func generateSavingPointsFromGoals(goals: [Goal]) -> [SavingPoint] {
//            return goals.map { goal in
//                let date = goal.modifiedDate ?? Date() // استخدم التاريخ من السجل أو الآن إذا لم يكن موجودًا
//                return SavingPoint(date: date, amount: goal.collectedAmount)
//            }
//        }
//    
//    func generateGroupedSavingPoints(from goals: [Goal], granularity: Calendar.Component) -> [SavingPoint] {
//        let calendar = Calendar.current
//        var grouped: [Date: Double] = [:]
//        
//        for goal in goals {
//            let date = goal.modifiedDate ?? Date()
//            let components = calendar.dateComponents([granularity], from: date)
//            if let groupedDate = calendar.date(from: components) {
//                grouped[groupedDate, default: 0.0] += goal.collectedAmount
//            }
//        }
//        
//        return grouped.map { SavingPoint(date: $0.key, amount: $0.value) }
//    }
//

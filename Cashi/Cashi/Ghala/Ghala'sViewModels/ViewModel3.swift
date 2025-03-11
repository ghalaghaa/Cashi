//// ViewModel3.swift
//import Foundation
//import CloudKit
//import SwiftUI
//
//class ViewModel3: ObservableObject {
//    @Published var calculations: [Calculation] = []
//    @Published var goals: [Goal] = []
//
//    init() {
//        fetchCalculations()
//        fetchGoals()
//    }
//
//    func fetchCalculations() {
//        // TODO: استرجاع البيانات من CloudKit
//    }
//
//    func fetchGoals() {
//        // TODO: استرجاع الأهداف من CloudKit
//    }
//
//    func deleteCalculation(calculation: Calculation) async {
//        // TODO: حذف العنصر من CloudKit
//    }
//
//    func updateCalculation(_ calculation: Calculation) async {
//        // TODO: تحديث العنصر في CloudKit
//    }
//
//    func calculateProgress(for calculation: Calculation) -> Double {
//        let progress = (calculation.salary / calculation.cost) * 100
//        return min(progress, 100)
//    }
//
//    func updateCalculationProgress(calculation: Calculation, increase: Bool) async {
//        var newSalary = calculation.salary
//        let increment = calculation.cost * 0.05
//        newSalary = increase ? newSalary + increment : max(0, newSalary - increment)
//
//        let updated = Calculation(
//            id: calculation.id,
//            goalName: calculation.goalName,
//            cost: calculation.cost,
//            salary: newSalary,
//            savingsType: calculation.savingsType,
//            savingsRequired: calculation.savingsRequired,
//            emoji: calculation.emoji
//        )
//
//        if let index = calculations.firstIndex(where: { $0.id == calculation.id }) {
//            DispatchQueue.main.async {
//                self.calculations[index] = updated
//            }
//        }
//
//        await updateCalculation(updated)
//    }
//
//    func matchGoal(for calculation: Calculation) -> Goal? {
//        goals.first(where: {
//            $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
//            calculation.goalName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
//        })
//    }
//}

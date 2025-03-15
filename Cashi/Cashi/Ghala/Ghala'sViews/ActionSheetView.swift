//
//  ContentView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
import SwiftUI
import Charts
import CloudKit

// ✅ شاشة عرض ملخص الإدخار (العرض الأولي)
struct CashTrackerView: View {
    var goals: [Goal] // ✅ استقبل الأهداف مباشرة
    @State private var showFullTracker = false
    
    var body: some View {
        let savingsData = generateGroupedSavingPoints(from: goals, granularity: .day) // ✅ تجميع البيانات مباشرة هنا

        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "160158"))
                .frame(height: 120)
                
            HStack {
                Chart {
                    ForEach(savingsData) { point in
                        LineMark(
                            x: .value("Date", point.date, unit: .day),
                            y: .value("Amount", point.amount)
                        )
                        .foregroundStyle(Color.blue)

                        if point == savingsData.last {
                            PointMark(
                                x: .value("Date", point.date),
                                y: .value("Amount", point.amount)
                            )
                            .foregroundStyle(Color.white)
                            .annotation(position: .top) {
                                Text("﷼ \(Int(point.amount))")
                                    .font(.caption)
                                    .bold()
                                    .padding(5)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                        }
                    }
                }
                .frame(height: 80)
                .padding(.leading, 16)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.trailing, 16)
            }
        }
        .padding(.horizontal, 16)
        .onTapGesture {
            showFullTracker = true
        }
        .sheet(isPresented: $showFullTracker) {
            FullCashTrackerView(goals: goals)
                .presentationDetents([.fraction(0.75)]) // ✅ 3/4 الشاشة
                .presentationDragIndicator(.visible)
        }
    }

    // ✅ نفس الدالة الموجودة في ViewModel ولكن هنا مختصرة:
    func generateGroupedSavingPoints(from goals: [Goal], granularity: Calendar.Component) -> [SavingPoint] {
        let calendar = Calendar.current
        var grouped: [Date: Double] = [:]
        
        for goal in goals {
            let date = goal.modifiedDate ?? Date()
            let components: DateComponents
            
            switch granularity {
            case .day:
                components = calendar.dateComponents([.year, .month, .day], from: date)
            case .month:
                components = calendar.dateComponents([.year, .month], from: date)
            case .year:
                components = calendar.dateComponents([.year], from: date)
            default:
                components = calendar.dateComponents([.year, .month, .day], from: date)
            }
            
            if let groupedDate = calendar.date(from: components) {
                grouped[groupedDate, default: 0.0] += goal.collectedAmount
            }
        }

        return grouped.map { SavingPoint(date: $0.key, amount: $0.value) }
            .sorted { $0.date < $1.date }
    }
}

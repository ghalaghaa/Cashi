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
    @State private var savingsData: [SavingPoint] = []
    @State private var showFullTracker = false // ✅ التحكم في التنقل إلى الشاشة الكاملة
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "160158"))
                .frame(height: 120)
                
            HStack {
                
                Chart {
                    ForEach(savingsData) { point in
                        LineMark(
                            x: .value("Date", point.date, unit: .day), // ✅ تم إضافة الوحدة الزمنية
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
        .onAppear {
            fetchSavingsData()
        }
        .onTapGesture {
            showFullTracker = true
        }
        .fullScreenCover(isPresented: $showFullTracker) {
            FullCashTrackerView(savingsData: savingsData)
        }
    }

    func fetchSavingsData() {
        let container = CKContainer(identifier: "iCloud.CashiBackup")
        let database = container.publicCloudDatabase
        let query = CKQuery(recordType: "Savings", predicate: NSPredicate(value: true))

        database.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("❌ خطأ في جلب البيانات: \(error.localizedDescription)")
                return
            }

            guard let records = records else { return }

            DispatchQueue.main.async {
                savingsData = records.compactMap { record in
                    guard let amount = record["amount"] as? Double,
                          let date = record["date"] as? Date else { return nil }
                    return SavingPoint(date: date, amount: amount)
                }
                savingsData.sort { $0.date < $1.date }
            }
        }
    }
}

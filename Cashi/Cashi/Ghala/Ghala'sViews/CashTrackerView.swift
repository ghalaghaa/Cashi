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

import SwiftUI
import Charts
import CloudKit

struct FullCashTrackerView: View {
    var savingsData: [SavingPoint]
    
    @State private var selectedPeriod = "Monthly"
    let periods = ["Weekly", "Monthly", "Yearly"]
    
    @State private var selectedDay = "Sunday"
    @State private var filteredData: [SavingPoint] = []
    
    @State private var currentDate: Date? // ✅ تاريخ البداية يعتمد على البيانات
    let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 20) {
            Text("CashTrack")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding(.top, 20)
            
            // ✅ أزرار الفترات الزمنية
            HStack {
                ForEach(periods, id: \.self) { period in
                    Button(action: {
                        selectedPeriod = period
                        filterData()
                    }) {
                        Text(period)
                            .font(.headline)
                            .bold()
                            .foregroundColor(selectedPeriod == period ? .white : .gray)
                            .padding()
                            .background(selectedPeriod == period ? Color.white.opacity(0.3) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "160158")))
            
            // ✅ شريط التاريخ والمبلغ (يتغير عند الضغط على الأسهم)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "160158"))
                    .frame(height: 80)

                HStack {
                    // ✅ زر السهم لليسار (يذهب إلى التاريخ السابق من `savingsData`)
                    Button(action: {
                        changeDate(toPrevious: true)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding()
                            .background(Circle().fill(Color(hex: "0E0137").opacity(0.6)))
                    }
                    .padding(.leading, 10)

                    Spacer()

                    // ✅ النص الأوسط (التاريخ والمبلغ يتغير حسب `filteredData`)
                    VStack(spacing: 5) {
                        Text(dateRangeString())
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .opacity(0.8)

                        Text("﷼ \(Int(filteredData.reduce(0) { $0 + $1.amount }))")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // ✅ زر السهم لليمين (يذهب إلى التاريخ التالي من `savingsData`)
                    Button(action: {
                        changeDate(toPrevious: false)
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding()
                            .background(Circle().fill(Color(hex: "0E0137").opacity(0.6)))
                    }
                    .padding(.trailing, 10)
                }
            }
            .padding(.horizontal, 16)
            
            // ✅ الرسم البياني
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "160158"))
                    .frame(height: 250)
                
                VStack {
                    Text("﷼ \(Int(filteredData.reduce(0) { $0 + $1.amount }))")
                        .font(.headline)
                        .bold()
                        .padding(8)
                        .background(Color(hex: "4B7EDA"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    
                    Chart {
                        ForEach(filteredData) { point in
                            BarMark(
                                x: .value("Date", point.date, unit: .day),
                                y: .value("Amount", point.amount)
                            )
                            .foregroundStyle(Color.blue)
                        }
                    }
                    .frame(height: 180)
                    .padding(.horizontal, 16)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .onAppear {
            if let firstDate = savingsData.first?.date {
                currentDate = firstDate // ✅ تعيين التاريخ الأول عند فتح الشاشة
                filterData()
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .ignoresSafeArea()
    }

    // ✅ تغيير التاريخ بناءً على السجلات الفعلية
    func changeDate(toPrevious: Bool) {
        guard let current = currentDate else { return }
        
        let sortedDates = savingsData.map { $0.date }.sorted()
        if let index = sortedDates.firstIndex(of: current) {
            let newIndex = toPrevious ? max(index - 1, 0) : min(index + 1, sortedDates.count - 1)
            currentDate = sortedDates[newIndex]
        }
        
        filterData()
    }

    // ✅ عرض نطاق التاريخ الفعلي من `filteredData`
    func dateRangeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        if let minDate = filteredData.map({ $0.date }).min(),
           let maxDate = filteredData.map({ $0.date }).max() {
            return "\(dateFormatter.string(from: minDate)) - \(dateFormatter.string(from: maxDate))"
        }
        
        return "No Data"
    }

    // ✅ تصفية البيانات بناءً على `currentDate`
    func filterData() {
        guard let current = currentDate else { return }
        
        filteredData = savingsData.filter { point in
            switch selectedPeriod {
            case "Weekly":
                return calendar.isDate(point.date, equalTo: current, toGranularity: .weekOfYear)
            case "Monthly":
                return calendar.isDate(point.date, equalTo: current, toGranularity: .month)
            case "Yearly":
                return calendar.isDate(point.date, equalTo: current, toGranularity: .year)
            default:
                return false
            }
        }
    }
}


// ✅ نموذج البيانات
struct SavingPoint: Identifiable, Equatable {
    var id = UUID()
    var date: Date
    var amount: Double
}

#Preview {
    CashTrackerView()
}


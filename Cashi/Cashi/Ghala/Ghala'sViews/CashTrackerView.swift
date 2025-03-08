//
//  CashTrackerView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 08/09/1446 AH.
//



////
////  ContentView.swift
////  Cashi
////
////  Created by Ghala Alnemari on 24/08/1446 AH.
//import SwiftUI
//import Charts
//import CloudKit
//
//struct CashTrackerView: View {
//    // ✅ بيانات الإدخار المسترجعة من `CloudKit`
//    @State private var savingsData: [SavingPoint] = []
//    @State private var showFullTracker = false // ✅ التحكم في فتح الصفحة الجديدة
//
//    var body: some View {
//        ZStack {
//            // ✅ خلفية الكاش تراكر
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color(hex: "160158"))
//                .frame(height: 120)
//
//            HStack {
//                // ✅ المخطط البياني الديناميكي
//                Chart {
//                    ForEach(savingsData) { point in
//                        LineMark(
//                            x: .value("Date", point.date, unit: .day),
//                            y: .value("Amount", point.amount)
//                        )
//                        .foregroundStyle(Color.blue)
//
//                        // ✅ نقطة مميزة على المخطط
//                        if point == savingsData.last {
//                            PointMark(
//                                x: .value("Date", point.date, unit: .day),
//                                y: .value("Amount", point.amount)
//                            )
//                            .foregroundStyle(Color.white)
//                            .annotation(position: .top) {
//                                Text("$\(Int(point.amount))")
//                                    .font(.caption)
//                                    .bold()
//                                    .padding(5)
//                                    .background(Color.blue.opacity(0.8))
//                                    .foregroundColor(.white)
//                                    .clipShape(RoundedRectangle(cornerRadius: 5))
//                            }
//                        }
//                    }
//                }
//                .frame(height: 80)
//                .padding(.leading, 16)
//
//                Spacer()
//
//                // ✅ السهم للانتقال إلى تفاصيل التراكير
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.white)
//                    .font(.title2)
//                    .padding(.trailing, 16)
//            }
//        }
//        .padding(.horizontal, 16)
//        .onAppear {
//            fetchSavingsData() // ✅ جلب البيانات عند فتح الشاشة
//        }
//        .onTapGesture {
//            showFullTracker = true
//        }
//        .fullScreenCover(isPresented: $showFullTracker) {
//            FullCashTrackerView()
//        }
//    }
//
//    // ✅ جلب البيانات من `CloudKit`
//    func fetchSavingsData() {
//        let container = CKContainer(identifier: "iCloud.CashiBackup") // ✅ استخدم الحاوية الصحيحة
//        let database = container.publicCloudDatabase
//        let query = CKQuery(recordType: "Savings", predicate: NSPredicate(value: true))
//
//        database.perform(query, inZoneWith: nil) { records, error in
//            if let error = error {
//                print("❌ خطأ في جلب البيانات: \(error.localizedDescription)")
//                return
//            }
//
//            guard let records = records else { return }
//
//            DispatchQueue.main.async {
//                savingsData = records.compactMap { record in
//                    guard let amount = record["amount"] as? Double,
//                          let date = record["date"] as? Date else { return nil }
//                    return SavingPoint(date: date, amount: amount)
//                }
//                savingsData.sort { $0.date < $1.date } // ✅ ترتيب البيانات حسب التاريخ
//            }
//        }
//    }
//}
//
//// ✅ نموذج بيانات الإدخار
//struct SavingPoint: Identifiable, Equatable {
//    var id = UUID()
//    var date: Date
//    var amount: Double
//}
//
//#Preview {
//    CashTrackerView()
//}
//
//struct FullCashTrackerView: View {
//    @State private var selectedPeriod = "Monthly"
//    let periods = ["Weekly", "Monthly", "Yearly"]
//    let days = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
//    @State private var selectedDay = "Sunday"
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("CashTrack")
//                .font(.largeTitle)
//                .bold()
//                .foregroundColor(.white)
//                .padding(.top, 20)
//
//            // ✅ أزرار الفترات
//            HStack {
//                ForEach(periods, id: \..self) { period in
//                    Button(action: {
//                        selectedPeriod = period
//                    }) {
//                        Text(period)
//                            .font(.headline)
//                            .bold()
//                            .foregroundColor(selectedPeriod == period ? .white : .gray)
//                            .padding()
//                            .background(selectedPeriod == period ? Color.white.opacity(0.3) : Color.clear)
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                    }
//                }
//            }
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "160158")))
//
//            // ✅ تاريخ ونسبة الادخار
//            ZStack {
//                RoundedRectangle(cornerRadius: 20)
//                    .fill(Color(hex: "160158"))
//                    .frame(height: 100)
//
//                HStack {
//                    Button(action: {}) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.white)
//                            .font(.title2)
//                    }
//                    .padding(.leading, 20)
//
//                    Spacer()
//
//                    VStack(spacing: 5) {
//                        Text("March 5, 2025 - March 6, 2025")
//                            .foregroundColor(.white)
//                        Text("﷼ 500")
//                            .font(.title)
//                            .bold()
//                            .foregroundColor(.white)
//                    }
//
//                    Spacer()
//
//                    Button(action: {}) {
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(.white)
//                            .font(.title2)
//                    }
//                    .padding(.trailing, 20)
//                }
//            }
//            .padding(.horizontal, 16)
//
//            // ✅ شريط الأيام
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 10) {
//                    ForEach(days, id: \..self) { day in
//                        Button(action: {
//                            selectedDay = day
//                        }) {
//                            Text(day)
//                                .font(.headline)
//                                .bold()
//                                .foregroundColor(selectedDay == day ? .white : .gray)
//                                .padding()
//                                .background(selectedDay == day ? Color.white.opacity(0.3) : Color.clear)
//                                .clipShape(RoundedRectangle(cornerRadius: 15))
//                        }
//                    }
//                }
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "160158")))
//            }
//        }
//        .padding(.horizontal, 16)
//        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]), startPoint: .topLeading, endPoint: .bottomTrailing))
//        .ignoresSafeArea()
//    }
//}
//
//
//#Preview {
//    FullCashTrackerView()
//}
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

// ✅ شاشة التفاصيل الكاملة عند الضغط على الكاش تراك
struct FullCashTrackerView: View {
    var savingsData: [SavingPoint]
    @State private var selectedPeriod = "Monthly"
    let periods = ["Weekly", "Monthly", "Yearly"]
    let days = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    @State private var selectedDay = "Sunday"
    @State private var filteredData: [SavingPoint] = []

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
            
            // ✅ تاريخ ونسبة الادخار
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "160158"))
                    .frame(height: 100)
                
                VStack(spacing: 5) {
                    Text("إجمالي المدخرات:")
                        .foregroundColor(.white)
                        .font(.headline)
                    Text("﷼ \(Int(filteredData.reduce(0) { $0 + $1.amount }))")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            
            // ✅ شريط الأيام
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(days, id: \.self) { day in
                        Button(action: {
                            selectedDay = day
                        }) {
                            Text(day)
                                .font(.headline)
                                .bold()
                                .foregroundColor(selectedDay == day ? .white : .gray)
                                .padding()
                                .background(selectedDay == day ? Color.white.opacity(0.3) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "160158")))
            }
            
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
                                x: .value("Date", point.date, unit: .day), // ✅ تم إضافة الوحدة الزمنية
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
            filterData()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .ignoresSafeArea()
    }

    func filterData() {
        let calendar = Calendar.current
        let now = Date()
        
        filteredData = savingsData.filter { point in
            switch selectedPeriod {
            case "Weekly":
                return calendar.isDate(point.date, equalTo: now, toGranularity: .weekOfYear)
            case "Monthly":
                return calendar.isDate(point.date, equalTo: now, toGranularity: .month)
            case "Yearly":
                return calendar.isDate(point.date, equalTo: now, toGranularity: .year)
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


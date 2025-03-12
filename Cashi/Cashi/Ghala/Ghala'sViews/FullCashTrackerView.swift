//
//  CashTrackSectionView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//
import SwiftUI
import Charts
import CloudKit

struct FullCashTrackerView: View {
    var savingsData: [SavingPoint]
    
    @State private var selectedPeriod = "Monthly"
    let periods = ["Weekly", "Monthly", "Yearly"]
    @Environment(\.presentationMode) var presentationMode

    
    @State private var selectedDay = "Sunday"
    @State private var filteredData: [SavingPoint] = []
    
    @State private var currentDate: Date? // ✅ تاريخ البداية يعتمد على البيانات
    let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 20) {
            Spacer() // دفع العناصر للأسفل أكثر
            
            HStack {
                // ✅ زر الرجوع
                Button(action: {
                    // الرجوع إلى View3
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding()
                }
                .padding(.leading, 10)
                .padding(.top, -150)

                Spacer()

                // ✅ عنوان CashTrack
                Text("CashTrack")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.leading, -50)
                    .padding(.top, 7)

                
                Spacer()
            }
            
//            .padding(.top, -150) // إنزال زر الرجوع والعنوان للأسفل قليلاً

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
                            .padding(8)
                            .frame(width: 80, height: 30) // تقليل الحجم هنا
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
            
            Spacer() // دفع العناصر للأسفل
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


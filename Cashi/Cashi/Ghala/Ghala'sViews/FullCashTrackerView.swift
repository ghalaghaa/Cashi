//
//  CashTrackSectionView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//
import SwiftUI
import Charts



struct FullCashTrackerView: View {
    var goals: [Goal]

    @State private var selectedPeriod = "Monthly"
    let periods = ["Weekly", "Monthly", "Yearly"]
    @State private var selectedDay = "Sunday"
    let weekDays = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

    @State private var filteredData: [SavingPoint] = []
    @State private var currentDate: Date? = Date()

    let calendar = Calendar.current
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            // زر الإغلاق في الأعلى يسار
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Circle().fill(Color.white.opacity(0.2)))
                }
                .padding(.top, 50)
                .padding(.leading, 21)

                Spacer()
            }
            .padding(.bottom, 5)

            // العنوان
            Text("CashTrack")
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            // أزرار الفترات الزمنية
            HStack(spacing: 10) {
                ForEach(periods, id: \.self) { period in
                    Button(action: {
                        selectedPeriod = period
                        updateFilteredData()
                    }) {
                        Text(period)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(selectedPeriod == period ? Color(hex: "64708D") : Color(hex: "160158"))
                            )
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "160158")))

            // شريط التاريخ والمبلغ
            HStack {
                Button(action: {
                    changeDate(toPrevious: true)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding()
                }

                Spacer()

                VStack(spacing: 6) {
                    Text(dateRangeString())
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Text("﷼ \(Int(filteredData.reduce(0) { $0 + $1.amount }))")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }

                Spacer()

                Button(action: {
                    changeDate(toPrevious: false)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "160158")))
            .padding(.horizontal)

            // شريط الأيام
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(weekDays, id: \.self) { day in
                        Button(action: {
                            if selectedDay == day {
                                // ✅ إذا تم الضغط على اليوم الحالي → انتقل لليوم التالي
                                if let currentIndex = weekDays.firstIndex(of: day) {
                                    let nextIndex = (currentIndex + 1) % weekDays.count
                                    selectedDay = weekDays[nextIndex]
                                }
                            } else {
                                // ✅ إذا تم الضغط على يوم آخر → حدده
                                selectedDay = day
                            }
                        }) {
                            Text(day)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule().fill(selectedDay == day ? Color(hex: "64708D") : Color(hex: "160158"))
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }

            // الرسم البياني
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(hex: "230285"), location: 0.8),
                                .init(color: Color(hex: "3002BE"), location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 200)

                VStack(spacing: 8) {
                    Text("﷼ \(Int(filteredData.reduce(0) { $0 + $1.amount }))")
                        .font(.headline)
                        .bold()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(hex: "4B7EDA"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())

                    Chart {
                        ForEach(filteredData) { point in
                            BarMark(
                                x: .value("Date", point.date),
                                y: .value("Amount", point.amount)
                            )
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .trailing) {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                                .foregroundStyle(.white)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(position: .bottom) {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: axisDateFormat())
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 150)
                    .padding(.horizontal, 24)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .onAppear {
            currentDate = Date()
            updateFilteredData()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .presentationDetents([.fraction(0.75)])
    }

    // MARK: - Helper Methods

    func changeDate(toPrevious: Bool) {
        guard let current = currentDate else { return }
        let sortedDates = filteredData.map { $0.date }.sorted()
        if let index = sortedDates.firstIndex(of: current) {
            let newIndex = toPrevious ? max(index - 1, 0) : min(index + 1, sortedDates.count - 1)
            currentDate = sortedDates[newIndex]
        }
        updateFilteredData()
    }

    func dateRangeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        if let minDate = filteredData.map({ $0.date }).min(),
           let maxDate = filteredData.map({ $0.date }).max() {
            return "\(formatter.string(from: minDate)) - \(formatter.string(from: maxDate))"
        }
        return "No Data"
    }

    func axisDateFormat() -> Date.FormatStyle {
        switch selectedPeriod {
        case "Weekly":
            return .dateTime.weekday()
        case "Monthly":
            return .dateTime.day().month()
        case "Yearly":
            return .dateTime.year()
        default:
            return .dateTime.day().month()
        }
    }

    func updateFilteredData() {
        let calendar = Calendar.current
        var grouped: [Date: Double] = [:]

        for goal in goals {
            let date = goal.modifiedDate ?? Date()
            let components: DateComponents

            switch selectedPeriod {
            case "Weekly":
                components = calendar.dateComponents([.year, .month, .day], from: date)
            case "Monthly":
                components = calendar.dateComponents([.year, .month], from: date)
            case "Yearly":
                components = calendar.dateComponents([.year], from: date)
            default:
                components = calendar.dateComponents([.year, .month, .day], from: date)
            }

            if let groupedDate = calendar.date(from: components) {
                grouped[groupedDate, default: 0.0] += goal.collectedAmount
            }
        }

        filteredData = grouped.map { SavingPoint(date: $0.key, amount: $0.value) }
            .sorted { $0.date < $1.date }
    }
}

// ✅ نموذج البيانات
struct SavingPoint: Identifiable, Equatable {
    var id = UUID()
    var date: Date
    var amount: Double
}

//import SwiftUI
//import CloudKit
//
//struct IndividualGoalsScrollView: View {
//    @ObservedObject var viewModel: ViewModel2
//    var onAddGoalTapped: () -> Void
//    @Binding var selectedGoal: Goal?
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 16) {
//                    ForEach(viewModel.goals.filter { $0.goalType == .individual }, id: \.id) { goal in
//                        ZStack(alignment: .topLeading) {
//                            if let imageData = goal.imageData, let uiImage = UIImage(data: imageData) {
//                                Image(uiImage: uiImage)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 220, height: 150)
//                                    .clipped()
//                                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                            } else {
//                                Image(systemName: "photo")
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 220, height: 150)
//                                    .clipped()
//                                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                            }
//
//                            RoundedRectangle(cornerRadius: 20)
//                                .fill(Color.black.opacity(0.4))
//                                .frame(width: 220, height: 150)
//
//                            VStack(alignment: .leading, spacing: 2) {
//                                Text(goal.name)
//                                    .font(.headline)
//                                    .bold()
//                                    .foregroundColor(.white)
//                                    .lineLimit(1)
//
//                                Text("Price: $\(goal.cost, specifier: "%.2f")")
//                                    .font(.caption)
//                                    .foregroundColor(.white)
//
//                                Text("Collected: $\(goal.collectedAmount, specifier: "%.2f")")
//                                    .font(.caption2)
//                                    .foregroundColor(.white)
//
//                                if goal.cost > 0 {
//                                    Text("\(Int((goal.collectedAmount / goal.cost) * 100))%")
//                                        .font(.caption)
//                                        .foregroundColor(.white)
//                                } else {
//                                    Text("0%")
//                                        .font(.caption)
//                                        .foregroundColor(.white)
//                                }
//                            }
//                            .padding(8)
//
//                            VStack {
//                                Spacer()
//                                VStack(spacing: 10) {
//                                    HStack(spacing: 150) {
//                                        Button(action: {
//                                            Task {
//                                                await updateProgress(for: goal, increase: true)
//                                            }
//                                        }) {
//                                            Image(systemName: "plus.circle.fill")
//                                                .resizable()
//                                                .frame(width: 30, height: 30)
//                                                .foregroundColor(.blue)
//                                        }
//
//                                        Button(action: {
//                                            Task {
//                                                await updateProgress(for: goal, increase: false)
//                                            }
//                                        }) {
//                                            Image(systemName: "minus.circle.fill")
//                                                .resizable()
//                                                .frame(width: 30, height: 30)
//                                                .foregroundColor(.blue)
//                                        }
//                                    }
//
//                                    GeometryReader { geometry in
//                                        ZStack(alignment: .leading) {
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .fill(Color.white.opacity(0.2))
//                                                .frame(height: 14)
//
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .fill(Color(hex: "4B7EDA"))
//                                                .frame(width: CGFloat(min(goal.collectedAmount / goal.cost, 1.0)) * geometry.size.width, height: 14)
//                                                .animation(.easeInOut(duration: 0.3), value: goal.collectedAmount)
//                                        }
//                                    }
//                                    .frame(width: 220, height: 14)
//                                    .padding(.top, 2)
//                                }
//                            }
//                            .frame(width: 220, height: 150)
//                        }
//                        .frame(width: 220, height: 150)
//                        .cornerRadius(20)
//                        .shadow(radius: 4)
//                        .onTapGesture {
//                            selectedGoal = goal
//                        }
//                    }
//
//                    Button(action: {
//                        onAddGoalTapped()
//                    }) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 15)
//                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
//                                .foregroundColor(.white.opacity(0.5))
//                                .frame(width: 220, height: 150)
//
//                            VStack(spacing: 6) {
//                                Image(systemName: "plus")
//                                    .font(.system(size: 28, weight: .bold))
//                                    .foregroundColor(.white)
//
//                                Text("Add Goal")
//                                    .font(.caption)
//                                    .foregroundColor(.white.opacity(0.8))
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal)
//            }
//        }
//    }
//    
//    // ✅ **إصلاح زر التقدم بحيث يعمل بشكل فوري**
//    private func updateProgress(for goal: Goal, increase: Bool) async {
//        let amountChange: Double = 10.0 // تعديل المبلغ الذي يتم إضافته أو إنقاصه
//        var newCollectedAmount = goal.collectedAmount + (increase ? amountChange : -amountChange)
//        newCollectedAmount = max(0, min(newCollectedAmount, goal.cost)) // تأكد أن القيم لا تتعدى الحدود
//
//        // تحديث الواجهة قبل إرسال البيانات لـ CloudKit
//        DispatchQueue.main.async {
//            if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
//                viewModel.goals[index].collectedAmount = newCollectedAmount
//            }
//        }
//
//        // تحديث القيم على CloudKit
//        await viewModel.updateGoalCollectedAmount(goal: goal, increase: increase)
//    }
//}
import SwiftUI
import CloudKit

struct IndividualGoalsScrollView: View {
    @ObservedObject var viewModel: ViewModel2
    var onAddGoalTapped: () -> Void
    @Binding var selectedGoal: Goal?

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.goals.filter { $0.goalType == .individual }, id: \.id) { goal in
                        ZStack(alignment: .topLeading) {
                            if let imageData = goal.imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .interpolation(.low) // ✅ تحسين الأداء وتقليل استهلاك الذاكرة
                                    .scaledToFill()
                                    .frame(width: 220, height: 150)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 220, height: 150)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }

                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.4))
                                .frame(width: 220, height: 150)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(goal.name)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)
                                    .lineLimit(1)

                                Text("Price: $\(goal.cost, specifier: "%.2f")")
                                    .font(.caption)
                                    .foregroundColor(.white)

                                Text("Collected: $\(goal.collectedAmount, specifier: "%.2f")")
                                    .font(.caption2)
                                    .foregroundColor(.white)

                                let progress = goal.cost > 0 ? goal.collectedAmount / goal.cost : 0
                                let safeProgress = progress.isFinite && progress >= 0 ? progress : 0
                                Text("\(Int(safeProgress * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding(8)

                            VStack {
                                Spacer()
                                VStack(spacing: 10) {
                                    HStack(spacing: 150) {
                                        Button(action: {
                                            Task {
                                                await updateProgress(for: goal, increase: true)
                                            }
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.blue)
                                        }

                                        Button(action: {
                                            Task {
                                                await updateProgress(for: goal, increase: false)
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.blue)
                                        }
                                    }

                                    GeometryReader { geometry in
                                        let progress = goal.cost > 0 ? goal.collectedAmount / goal.cost : 0
                                        let safeProgress = progress.isFinite && progress >= 0 ? min(progress, 1.0) : 0
                                        let barWidth = safeProgress * geometry.size.width

                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white.opacity(0.2))
                                                .frame(height: 14)

                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(hex: "4B7EDA"))
                                                .frame(width: barWidth, height: 14)
                                                .animation(.easeInOut(duration: 0.3), value: goal.collectedAmount)
                                        }
                                    }
                                    .frame(width: 220, height: 14)
                                    .padding(.top, 2)
                                }
                            }
                            .frame(width: 220, height: 150)
                        }
                        .frame(width: 220, height: 150)
                        .cornerRadius(20)
                        .shadow(radius: 4)
                        .onTapGesture {
                            selectedGoal = goal
                        }
                    }

                    Button(action: {
                        onAddGoalTapped()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundColor(.white.opacity(0.5))
                                .frame(width: 220, height: 150)

                            VStack(spacing: 6) {
                                Image(systemName: "plus")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)

                                Text("Add Goal")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // ✅ تحديث فوري لتقدم الهدف
    private func updateProgress(for goal: Goal, increase: Bool) async {
        let amountChange: Double = 10.0
        var newCollectedAmount = goal.collectedAmount + (increase ? amountChange : -amountChange)
        newCollectedAmount = max(0, min(newCollectedAmount, goal.cost))

        DispatchQueue.main.async {
            if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
                viewModel.goals[index].collectedAmount = newCollectedAmount
            }
        }

        await viewModel.updateGoalCollectedAmount(goal: goal, increase: increase)
    }
}

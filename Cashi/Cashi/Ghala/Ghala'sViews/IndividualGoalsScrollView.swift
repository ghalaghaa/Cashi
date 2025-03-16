//
//  CashTrackSectionView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//
import SwiftUI
import CloudKit

struct IndividualGoalsScrollView: View {
    @ObservedObject var viewModel: ViewModel2
    var onAddGoalTapped: () -> Void
    @Binding var selectedGoal: Goal?
    @State private var showWidgetSelectionAlert = false
    @State private var goalToSetAsWidget: Goal?
    @Binding var widgetGoal: Goal? // الهدف الذي تم اختياره للودجت
    @Binding var isSelectingGoals: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.goals.filter { $0.goalType == .individual && $0.ownerID == viewModel.user?.id }, id: \.id) { goal in
                        ZStack(alignment: .topLeading) {
                            if isSelectingGoals && selectedGoal?.id == goal.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.blue)
                                    .background(Color.white.clipShape(Circle()))
                                    .offset(x: 180, y: 10) // اضبط الإحداثيات حسب المكان اللي يناسبك
                            }
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
                           
                            
                            
                            
                            if goal.isWidgetGoal {
                                Image(systemName: "pin.fill")
                                    .foregroundColor(.yellow)
                                    .padding(6)
                            }

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
                            if isSelectingGoals {
                                selectedGoal = goal
                            } else {
                                goalToSetAsWidget = goal
                                showWidgetSelectionAlert = true
                            }
                        }
                        
                        
                        .alert("Set this goal as Widget Goal?", isPresented: Binding(
                               get: { showWidgetSelectionAlert && goalToSetAsWidget?.id == goal.id },
                               set: { showWidgetSelectionAlert = $0 }
                           )) {
                               Button("Done") {
                                   if let selectedGoal = goalToSetAsWidget {
                                       widgetGoal = selectedGoal
                                       Task {
                                           await viewModel.resetAllWidgetGoals(except: selectedGoal.id)
                                           await viewModel.setGoalAsWidgetGoal(selectedGoal)
                                           // تحديث الحالة المحلية للـ isWidgetGoal
                                           DispatchQueue.main.async {
                                               for index in viewModel.goals.indices {
                                                   viewModel.goals[index].isWidgetGoal = (viewModel.goals[index].id == selectedGoal.id)
                                               }
                                           }
                                       }
                                   }
                               }
                               Button("Cancel", role: .cancel) { }
                           } message: {
                               Text("Would you like to pin this goal to the widget?")
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

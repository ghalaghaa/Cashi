//
//  IndividualGoalsScrollView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.

import SwiftUI
import CloudKit

struct IndividualGoalsScrollView: View {
    var viewModel: ViewModel2
    var onAddGoalTapped: () -> Void
    @Binding var selectedGoal: Goal?

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.goals.filter { $0.goalType == .individual }, id: \.id) { goal in
                        ZStack(alignment: .topLeading) {
                            // ✅ صورة الخلفية
                            if let imageData = goal.imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
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

                            // ✅ طبقة تعتيم
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.4))
                                .frame(width: 220, height: 150)

                            
                            if selectedGoal?.id == goal.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .padding(8)
                            }
                            
                            // ✅ معلومات الهدف في الأعلى يسار
                            VStack(alignment: .leading, spacing: 2) {
                                Text(goal.name)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)
                                    .lineLimit(1)

                                Text("Price: $\(goal.cost, specifier: "%.2f")")
                                    .font(.caption)
                                    .foregroundColor(.white)

                                Text("Collected: $\(goal.salary, specifier: "%.2f")")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            }
                            .padding(8)

                            // ✅ عناصر التفاعل أسفل البطاقة
                            VStack {
                                Spacer()
                                VStack(spacing: 10) {
                                    // أزرار + و -
                                    HStack(spacing: 150) { // ← أبعدنا الأزرار عن بعض
                                        Button(action: {
                                            // ناقص
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(Color(hex: "4B7EDA"))
                                        }

                                        Button(action: {
                                            // زائد
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(Color(hex: "4B7EDA"))
                                        }
                                    }

                                    // ✅ Progress Bar في الأسفل
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white.opacity(0.2))
                                                .frame(height: 14)

                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(hex: "4B7EDA"))
                                                .frame(width: CGFloat(min(goal.salary / goal.cost, 1.0)) * geometry.size.width, height: 14)
                                        }
                                    }
                                    .frame(width: 220, height: 14)
                                    .padding(.top, 2) // ← نزول البار أكثر
                                }
                            }
                            .frame(width: 220, height: 150)
                        }
                        .frame(width: 220, height: 150)
                        .cornerRadius(20)
                        .shadow(radius: 4)
                    }

                    // ✅ زر إضافة هدف جديد
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
}

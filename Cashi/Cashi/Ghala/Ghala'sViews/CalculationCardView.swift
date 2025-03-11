////
////  CalculationCardView.swift.swift
////  Cashi
////
////  Created by Ghala Alnemari on 10/09/1446 AH.
////
//
//// CalculationCardView.swift
//import SwiftUI
//
//struct CalculationCardView: View {
//    let calculation: Calculation
//    let goal: Goal?
//    let isSelected: Bool
//    let isSelecting: Bool
//    let onSelect: () -> Void
//    let onIncrease: () -> Void
//    let onDecrease: () -> Void
//    let progress: Double
//
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            RoundedRectangle(cornerRadius: 15)
//                .fill(Color.white.opacity(0.2))
//                .frame(width: 220, height: 140)
//                .shadow(radius: 4)
//
//            if let goal = goal, let imageData = goal.imageData, let uiImage = UIImage(data: imageData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 220, height: 140)
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//            } else {
//                Text(calculation.emoji)
//                    .font(.system(size: 40))
//                    .frame(width: 220, height: 140)
//                    .background(Color.black.opacity(0.3))
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//            }
//
//            VStack(alignment: .leading) {
//                Text(calculation.goalName)
//                    .font(.caption)
//                    .foregroundColor(.white.opacity(0.8))
//                    .bold()
//
//                Text("$\(Int(calculation.cost))")
//                    .font(.title3)
//                    .bold()
//                    .foregroundColor(.white)
//
//                Text("\(Int(progress))%")
//                    .font(.caption)
//                    .bold()
//                    .foregroundColor(.white.opacity(0.8))
//            }
//            .padding()
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .padding(10)
//
//            VStack {
//                Spacer()
//                HStack {
//                    Button(action: onDecrease) {
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 30, height: 30)
//                            .overlay(Image(systemName: "minus").foregroundColor(.white))
//                    }
//                    .padding(.leading, 10)
//
//                    ProgressView(value: progress / 100, total: 1.0)
//                        .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
//                        .frame(width: 130)
//                        .animation(.easeInOut, value: progress)
//
//                    Button(action: onIncrease) {
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 30, height: 30)
//                            .overlay(Image(systemName: "plus").foregroundColor(.white))
//                    }
//                    .padding(.trailing, 10)
//                }
//                .padding(.bottom, 10)
//            }
//
//            if isSelecting {
//                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
//                    .resizable()
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(isSelected ? .blue : .white)
//                    .padding(8)
//                    .onTapGesture { onSelect() }
//            }
//        }
//    }
//}

//
//  QattahGoalsView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//

import SwiftUI
import CloudKit

struct QattahGoalsView: View {
    @ObservedObject var viewModel: ViewModel2
    @Binding var showOptionsSheet: Bool
    @State private var showProgressSheet: Bool = false
    var userName: String
    var currentUser: User

    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.qattahGoals, id: \.id) { goal in
                        ZStack(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(hex: "290B83"))
                                .frame(width: 240, height: 300)
                                .shadow(radius: 4)

                            VStack(alignment: .leading, spacing: 4) {
                                // زر الثلاث نقاط
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        showProgressSheet = true
                                    }) {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.white)
                                            .padding(.trailing, 12)
                                            .padding(.top, 12)
                                            .padding(.leading, -9)
                                    }
                                }

                                HStack {
                                    ZStack {
                                        Circle()
                                            .stroke(lineWidth: 6)
                                            .foregroundColor(.gray.opacity(0.3))
                                            .frame(width: 60, height: 60)
                                        
                                        let progress = min(max(goal.collectedAmount / goal.cost, 0), 1.0) // ✅ حساب التقدم الصحيح
                                        
                                        ZStack {
                                            Circle()
                                                .stroke(lineWidth: 6)
                                                .foregroundColor(.gray.opacity(0.3))
                                                .frame(width: 60, height: 60)
                                            
                                            Circle()
                                                .trim(from: 0, to: progress) // ✅ استخدم progress هنا
                                                .stroke(Color(hex: "007AFF"), lineWidth: 6) // ✅ تطبيق stroke على الدائرة وليس على progress
                                                .frame(width: 60, height: 60)
                                                .rotationEffect(.degrees(-90)) // ✅ تصحيح دوران الدائرة
                                            
                                            Text(goal.emoji)
                                                .font(.title3)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.leading, 10)

                                    VStack(alignment: .leading) {
                                        Text(goal.name)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .bold()
                                        Text("\(goal.salary.formatted())% Achieved")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                .padding(.top, 10)

                                VStack {
                                    HStack {
                                        Text(userName)
                                            .font(.callout)
                                            .foregroundColor(.white)
                                            .padding(.leading, 8)
                                        Spacer()
                                    }
                                    .padding(.top, 8)

                                    ZStack {
                                        ProgressView(value: Double(min(max(goal.collectedAmount / goal.cost, 0), 1.0)), total: 1.0)
                                            .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "007AFF")))
                                            .frame(height: 20)
                                            .padding(.top, 6)

                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .offset(x: CGFloat(min(max(goal.collectedAmount / goal.cost, 0), 1.0)) * 200 - 100)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(width: 240, height: 300)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 350)
        }
        // هنا فقط نربط الشيت وليس خارجه
        .sheet(isPresented: $showProgressSheet) {
            ProgressSheetView(currentUser: currentUser, challengeName: "رمضان قطه")
                .presentationDetents([.fraction(0.75)])
        
        
        }
    }
}

#Preview {
    View3()
}

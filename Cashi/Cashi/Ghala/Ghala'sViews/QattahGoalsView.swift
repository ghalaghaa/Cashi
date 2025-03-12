//
//  QattahGoalsView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//

import SwiftUI
import CloudKit

struct QattahGoalsView: View {
    var viewModel: ViewModel2
    @Binding var showOptionsSheet: Bool

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.qattahGoals, id: \.id) { goal in
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "290B83"))
                            .frame(width: 240, height: 300)
                            .shadow(radius: 4)

                        VStack(alignment: .leading, spacing: 10) {
                            // ✅ زر الثلاث نقاط أعلى يمين المربع
                            HStack {
                                Spacer()
                                Button(action: {
                                    showOptionsSheet = true
                                }) {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.white)
                                        .padding(.trailing, 12)
                                        .padding(.top, 12)
                                }
                            }

                            // ✅ باقي المحتوى مرتفع للأعلى
                            VStack(alignment: .leading, spacing: 8) {
                                // الدائرة مع الإيموجي
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 6)
                                        .foregroundColor(.gray.opacity(0.3))
                                        .frame(width: 60, height: 60)

                                    Circle()
                                        .trim(from: 0, to: 0.2)
                                        .stroke(Color(hex: "007AFF"), lineWidth: 6)
                                        .frame(width: 60, height: 60)
                                        .rotationEffect(.degrees(-90))

                                    Text(goal.emoji)
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }

                                Text(goal.name)
                                    .font(.subheadline)
                                    .foregroundColor(.white)

                                Text("\(goal.salary.formatted())% Achieved")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 16)
                            .padding(.top, -10) // رفع العناصر قليلًا للأعلى
                            
                            Spacer()
                        }
                    }
                    .frame(width: 240, height: 300)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 350)
    }
}

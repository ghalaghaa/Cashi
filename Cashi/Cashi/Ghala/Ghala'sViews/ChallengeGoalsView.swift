//
//  ChallengeGoalsView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//
import SwiftUI
import CloudKit

struct ChallengeGoalsView: View {
    var viewModel: ViewModel2

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(viewModel.challengeGoals, id: \.id) { goal in
                    VStack(spacing: 3) {
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 6)
                                .foregroundColor(.gray.opacity(0.3))
                                .frame(width: 90, height: 90)

                            Circle()
                                .trim(from: 0, to: CGFloat(goal.salary) / 100)
                                .stroke(Color(hex: "007AFF"), lineWidth: 6)
                                .frame(width: 90, height: 90)
                                .rotationEffect(.degrees(-90))

                            Image(systemName: goal.emoji)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                                .padding(5)
                        }

                        Text(goal.name)
                            .font(.caption)
                            .foregroundColor(.white)
                            .bold()

                        Text("\(Int(goal.salary))% achieved")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 3)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 5)
    }
}

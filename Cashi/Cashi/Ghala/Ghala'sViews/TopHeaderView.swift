//
//  TopHeaderView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//
import SwiftUI
import CloudKit

struct TopHeaderView: View {
    var onAddTapped: () -> Void
    @Binding var selectedGoals: [Goal]
    @Binding var isSelectingCalculations: Bool
    var userName: String // ✅ استبدال viewModel بـ userName

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)

                Text("Hi, \(userName.isEmpty ? "جاري جلب البيانات..." : userName)")
                    .foregroundColor(.white)
                    .font(.headline)

                Spacer()

                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color(hex: "290B83"), Color(hex: "4B7EDA"))
                    .padding(.trailing, 16)
                    .onTapGesture {
                        onAddTapped()
                    }
            }

            HStack {
                Text("Goals")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.leading, 16)

                Spacer()

                Button("Select") {
                    if selectedGoals.isEmpty {
                        print("⚠️ لم يتم تحديد أي هدف!")
                    } else {
                        isSelectingCalculations = true
                    }
                }
                .foregroundColor(.blue)
                .padding(.trailing, 16)
            }
        }
    }
}

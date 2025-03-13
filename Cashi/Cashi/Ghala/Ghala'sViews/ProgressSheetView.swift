//
//  ProgressSheetView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//
import SwiftUI

struct ProgressSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var amountText: String = ""

    var body: some View {
        ZStack {
            // خلفية التدرج تغطي كامل الشاشة
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // العنوان
                Text("Edit Your Progress")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 16)

                // إدخال المبلغ
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Amount")
                        .foregroundColor(.white)
                        .font(.callout)

                    TextField("Enter amount...", text: $amountText)
                        .padding()
                        .background(Color(hex: "160158"))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal, 24)

                // عنوان progress
                Text("Your Friends Progress")
                    .font(.headline)
                    .foregroundColor(.white)

                // قائمة الأصدقاء + زر إضافة
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach([
                            ("Ghala", "person.circle.fill", 0.35),
                            ("Sara", "person.circle.fill", 0.05),
                            ("Yara", "person.circle.fill", 0.30),
                            ("Talal", "person.circle.fill", 0.10)
                        ], id: \.0) { friend in
                            VStack(spacing: 6) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 80, height: 120)

                                    ZStack(alignment: .bottom) {
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                                startPoint: .bottom,
                                                endPoint: .top))
                                            .frame(width: 80, height: 120 * friend.2)
                                    }
                                    .frame(width: 80, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 40))

                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.blue, lineWidth: 2)
                                        .frame(width: 80, height: 120)

                                    VStack(spacing: 4) {
                                        Image(systemName: friend.1)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 35, height: 35)
                                            .foregroundColor(.white)

                                        Text("\(Int(friend.2 * 100))%")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                    }
                                }
                                Text(friend.0)
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                        }

                        // زر إضافة صديق
                        VStack(spacing: 6) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 80, height: 120)

                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(width: 80, height: 120)

                                Image(systemName: "plus")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                            Text("Add Friend")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                // زر نكست أسفل يمين
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Next")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 16)
                }
            }
            .frame(maxHeight: .infinity) // هذه النقطة المهمة لتغطية كامل مساحة الشيت
        }
    }
}

//
//  EditGoalSheetView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//
import SwiftUI
import CloudKit

struct EditGoalSheetView: View {
    @Binding var showEditSheet: Bool
    @Binding var newAmount: String
    @Binding var selectedGoalToEdit: Goal?

    var body: some View {
        EmptyView()
            .sheet(isPresented: $showEditSheet) {
                VStack(alignment: .leading, spacing: 20) {
                    Capsule().frame(width: 40, height: 5).foregroundColor(.white.opacity(0.6)).padding(.top, 10)

                    Text("Edit Goal").font(.title).bold().foregroundColor(.white).padding(.horizontal)
                    Text("Enter Amount").foregroundColor(.white).padding(.horizontal)

                    TextField("Enter Amount", text: $newAmount)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(hex: "1A0F66"))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                        .padding(.horizontal)

                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        showEditSheet = false
                        selectedGoalToEdit = nil
                    } label: {
                        Text("Save").bold().frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(15)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]), startPoint: .top, endPoint: .bottom).ignoresSafeArea())
                .presentationDetents([.fraction(0.75)])
            }
    }
}

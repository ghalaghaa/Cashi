////
////  EditCalculationView.swift
////  Cashi
////
////  Created by Ghala Alnemari on 10/09/1446 AH.
////
//
//// EditCalculationView.swift
//import SwiftUI
//import CloudKit
//
//struct EditCalculationView: View {
//    @ObservedObject var viewModel: ViewModel3
//    @Binding var selectedCalculationIDs: Set<CKRecord.ID>
//    @Binding var newAmount: String
//    @Binding var showEditSheet: Bool
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            Capsule()
//                .frame(width: 40, height: 5)
//                .foregroundColor(.white.opacity(0.6))
//                .padding(.top, 10)
//                .frame(maxWidth: .infinity, alignment: .center)
//
//            Text("Edit Goal")
//                .font(.title)
//                .bold()
//                .foregroundColor(.white)
//                .padding(.horizontal)
//
//            Text("Enter Amount")
//                .foregroundColor(.white)
//                .padding(.horizontal)
//
//            TextField("Enter Amount", text: $newAmount)
//                .keyboardType(.numberPad)
//                .padding()
//                .background(Color(hex: "1A0F66"))
//                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.blue, lineWidth: 1)
//                )
//                .padding(.horizontal)
//
//            Button {
//                if let amount = Double(newAmount),
//                   let firstID = selectedCalculationIDs.first,
//                   let index = viewModel.calculations.firstIndex(where: { $0.id == firstID }) {
//
//                    viewModel.calculations[index].cost = amount
//
//                    // تحديث البيانات في iCloud مباشرة إن رغبت بذلك:
//                    let updatedCalculation = viewModel.calculations[index]
//                    Task {
//                        await viewModel.updateCalculation(updatedCalculation)
//                    }
//                }
//                showEditSheet = false
//            } label: {
//                Text("Save")
//                    .font(.body)
//                    .bold()
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(15)
//            }
//            .padding(.horizontal)
//
//            Spacer()
//        }
//        .padding()
//        .background(
//            LinearGradient(
//                gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//        )
//        .presentationDetents([.fraction(0.75)])
//    }
//}

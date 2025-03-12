//
//  GoalsSheetView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//
import SwiftUI
import CloudKit
struct GoalsSheetView: View {
    @Binding var selectedGoals: [Goal]
    @Binding var isSelectingCalculations: Bool
    @Binding var selectedGoalToEdit: Goal?
    @Binding var shouldOpenEditSheet: Bool
    @Binding var showEditSheet: Bool
    @Binding var isSelectingGoals: Bool

    var body: some View {
        EmptyView()
            .sheet(isPresented: Binding(
                get: { !selectedGoals.isEmpty && isSelectingCalculations },
                set: { newValue in
                    if !newValue {
                        selectedGoals.removeAll()
                        isSelectingCalculations = false
                    }
                })) {
                    VStack(spacing: 20) {
                        Capsule().frame(width: 40, height: 5).foregroundColor(.white.opacity(0.6)).padding(.top, 10)

                        if let selectedGoal = selectedGoals.first {
                            Button {
                                selectedGoalToEdit = selectedGoal
                                shouldOpenEditSheet = true
                                selectedGoals.removeAll()
                            } label: {
                                HStack {
                                    Text("Edit").bold().foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "pencil").foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(15)
                            }
                            .padding(.horizontal)
                        }

                        Button(role: .destructive) {
                            selectedGoals.removeAll()
                            isSelectingGoals = false
                        } label: {
                            HStack {
                                Text("Delete").bold().foregroundColor(.red)
                                Spacer()
                                Image(systemName: "trash").foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]), startPoint: .top, endPoint: .bottom).ignoresSafeArea())
                    .presentationDetents([.fraction(0.25)])
                    .interactiveDismissDisabled(false)
                    .onDisappear {
                        if shouldOpenEditSheet {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showEditSheet = true
                                shouldOpenEditSheet = false
                    }
                }
            }
        }
    }
}

import SwiftUI
import CloudKit

struct CalculationPage: View {
    let goal: Goal
    let cost: Double
    let salary: Double
    let savingsType: Goal.SavingsType

    @State private var savingsPerPeriod: Double = 0
    @State private var duration: Int = 0
    @State private var navigateToEdit = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "1F0179"),
                    Color(hex: "160158"),
                    Color(hex: "0E0137")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 15) {
                headerView()

                VStack(spacing: 15) {
                    // Monthly Payment Section
                    inputField(title: "Your Monthly Payment", value: String(format: "%.2f $", savingsPerPeriod))
                        .overlay(editButton()) // Add pencil button

                    // Time Needed Section
                    inputField(title: "Time Needed to Reach Your Goal", value: "\(duration) months")
                        .overlay(editButton())
                }
                .frame(width: 380, height: 220)
                .background(RoundedRectangle(cornerRadius: 30).fill(Color(hex: "1C215B")))
                .padding(.horizontal)

                // Next Button
                nextButton()
            }
        }
        .onAppear {
            Task {
                let savingRate = 0.2
                let calculatedSavingsPerPeriod = salary * savingRate
                let calculatedDuration = Int(ceil(cost / calculatedSavingsPerPeriod))

                await MainActor.run {
                    duration = calculatedDuration
                    savingsPerPeriod = calculatedSavingsPerPeriod
                }
            }
        }
//        .background(
//            NavigationLink("", destination: GoalSelectionView(), isActive: $navigateToEdit)
//                .hidden()
//        )
    }

    // MARK: - Header View
    private func headerView() -> some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)

            Text("Good evening, Linah")  // Replace with actual user data
                .foregroundColor(.white)
                .font(.headline)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 50)
    }

    // MARK: - Input Field
    private func inputField(title: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
                .font(.headline)

            Text(value)
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }

    // MARK: - Edit Button (Pencil)
    private func editButton() -> some View {
        HStack {
            Spacer()
            Button(action: { navigateToEdit = true }) {
                Image(systemName: "pencil")
                    .foregroundColor(.white)
                    .padding(10)
            }
        }
        .padding(.trailing, 10)
    }

    // MARK: - Next Button
    private func nextButton() -> some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Text("Next")
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.blue)
                .cornerRadius(25)
        }
        .padding(.top, 20)
    }
}

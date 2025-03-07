import SwiftUI
import CloudKit

struct SetGoalCostView: View {
    let goal: Goal

    @State private var cost = ""
    @State private var salary = ""
    @State private var selectedSavingsType: Goal.SavingsType = .monthly
    @State private var navigateToCalculation = false

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

            VStack(spacing: 20) {
                headerView()

                VStack(spacing: 20) {
                    // Time Period Picker
                    Text("Choose Your Time Period")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Picker("Time Period", selection: $selectedSavingsType) {
                        Text("Daily").tag(Goal.SavingsType.daily)
                        Text("Weekly").tag(Goal.SavingsType.weekly)
                        Text("Monthly").tag(Goal.SavingsType.monthly)
                        Text("Yearly").tag(Goal.SavingsType.yearly)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    // Goal Cost Input
                    inputField(title: "Set Your Goal Cost", text: $cost)

                    // Salary Input Field (NEW ✅)
                    inputField(title: "Enter Your Salary", text: $salary)

                    // Next Button
                    nextButton()
                }
                .frame(width: 380, height: 350) // Adjusted height
                .background(RoundedRectangle(cornerRadius: 30).fill(Color(hex: "1C215B")))
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

        NavigationLink(
            destination: CalculationPage(
                goal: goal,
                cost: Double(cost) ?? 0,
                salary: Double(salary) ?? 0, // ✅ Passing Salary to CalculationPage
                savingsType: selectedSavingsType
            ),
            isActive: $navigateToCalculation
        ) {
            EmptyView()
        }
        .hidden()
    }

    // MARK: - Header View
    private func headerView() -> some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)

            Text("Good evening, Linah") // Replace with actual user data if needed
                .foregroundColor(.white)
                .font(.headline)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 50)
    }

    // MARK: - Input Field
    private func inputField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
                .font(.headline)

            TextField(title, text: text)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
                .foregroundColor(.white)
                .keyboardType(.decimalPad)
                .padding(.horizontal)
        }
    }

    // MARK: - Next Button
    private func nextButton() -> some View {
        Button(action: { navigateToCalculation = true }) {
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

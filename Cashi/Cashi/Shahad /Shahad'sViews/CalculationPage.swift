import SwiftUI
import CloudKit
import Foundation

struct CalculationPage: View {
    let user: User
    @Binding var goal: Goal
    let cost: Double
    let salary: Double
    let savingsType: Goal.SavingsType

    @StateObject private var viewModel: ViewModel2
    @State private var savingsPerPeriod: Double = 0
    @State private var duration: Int = 0
    @State private var navigateToEdit = false
    @State private var navigateToView3 = false
    @State private var savingRate: Double = 0.2

    @Environment(\.presentationMode) var presentationMode

    init(user: User, goal: Binding<Goal>, cost: Double, savingsType: Goal.SavingsType) {
        self.user = user
        self._goal = goal
        self.cost = cost
        self.savingsType = savingsType
        self.salary = goal.wrappedValue.salary // ✅ fix here
        _viewModel = StateObject(wrappedValue: ViewModel2(user: user))
    }
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient()

                VStack(spacing: 25) {
                    headerView()

                    VStack(spacing: 20) {
                        inputField(title: "Your \(savingsType.rawValue.capitalized) Payment", value: String(format: "%.2f $", savingsPerPeriod))
                        inputField(title: "Time Needed to Reach Your Goal", value: "\(duration) \(savingsType.rawValue.lowercased())s")
                        savingsRateSlider()
                    }
                    .frame(width: 400, height: 500)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "243470"), Color(hex: "1C215B"), Color(hex: "120248")]),
                            startPoint: .topLeading,
                            endPoint: .bottomLeading
                        )
                        .cornerRadius(30)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 40)

                    Spacer()

                    HStack {
                        Spacer()
                        nextButton()
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                calculateSavings()
            }
            .onChange(of: savingRate) { _ in
                calculateSavings()
            }
            
            // ✅ **Navigation to View3**
            NavigationLink(
                destination: View3(),
                isActive: $navigateToView3
            ) {
                EmptyView()
            }
            .hidden()
        }
    }

    private func backgroundGradient() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private func headerView() -> some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.blue)

            Text("Hi, \(user.name)")
                .foregroundColor(.white)
                .font(.headline)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.leading, 10)
        .padding(.bottom, 39)
    }

    private func inputField(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 20)

            Text(value)
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
        }
    }

    private func savingsRateSlider() -> some View {
        VStack {
            Text("Adjust Savings Rate: \(Int(savingRate * 100))%")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 20)

            Slider(value: $savingRate, in: 0.05...0.5, step: 0.05)
                .padding(.horizontal, 20)
        }
    }

    private func nextButton() -> some View {
        Button(action: {
            saveGoalAndNavigate()
        }) {
            Text("Next")
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.blue)
                .cornerRadius(25)
        }
    }

    private func saveGoalAndNavigate() {
        goal.cost = cost
        goal.salary = salary
        goal.savingsType = savingsType

        Task {
            let success = await viewModel.saveGoal(goal: goal)
            DispatchQueue.main.async {
                if success {
                    navigateToView3 = true
                } else {
                    print("⚠️ Failed to save goal.")
                }
            }
        }
    }

    private func calculateSavings() {
        let salaryFromGoal = goal.salary

        guard salaryFromGoal > 0, cost > 0 else {
            savingsPerPeriod = 0
            duration = 0
            return
        }

        let savingFactor: Double
        switch savingsType {
        case .daily: savingFactor = 30.0
        case .weekly: savingFactor = 4.0
        case .monthly: savingFactor = 1.0
        }

        let calculated = (salaryFromGoal * savingRate) / savingFactor
        let durationNeeded = calculated > 0 ? Int(ceil(cost / calculated)) : 0

        savingsPerPeriod = calculated
        duration = max(1, durationNeeded)
    
    }
}


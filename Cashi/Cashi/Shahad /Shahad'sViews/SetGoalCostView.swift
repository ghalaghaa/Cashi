import SwiftUI
import CloudKit

struct SetGoalCostView: View {
    @Binding var goal: Goal // ✅ Use @Binding to ensure changes persist
    let user: User

    @State private var cost: String
    @State private var salary: String
    @State private var selectedSavingsType: Goal.SavingsType
    @State private var navigateToCalculation = false

    @StateObject private var viewModel: ViewModel2

    init(goal: Binding<Goal>, user: User) {
        self._goal = goal
        self.user = user
        _cost = State(initialValue: "\(goal.wrappedValue.cost)")
        _salary = State(initialValue: "\(goal.wrappedValue.salary)")
        _selectedSavingsType = State(initialValue: goal.wrappedValue.savingsType)

        _viewModel = StateObject(wrappedValue: ViewModel2(user: user))
    }

    var body: some View {
        ZStack {
            backgroundGradient()

            VStack(spacing: 20) {
                headerView()

                VStack(spacing: 15) {
                    Text("Choose Your Goal Type")
                        .foregroundColor(.white)
                        .font(.headline)

                    inputFields()

                    Text("Choose Your Time Period")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Picker("Time Period", selection: $selectedSavingsType) {
                        Text("Daily").tag(Goal.SavingsType.daily)
                        Text("Weekly").tag(Goal.SavingsType.weekly)
                        Text("Monthly").tag(Goal.SavingsType.monthly)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    nextButton()
                }
                .frame(width: 380, height: 400)
                .background(RoundedRectangle(cornerRadius: 30).fill(Color(hex: "1C215B")))
                .padding(.horizontal)

                Spacer()
            }

            // ✅ NavigationLink to CalculationPage
            NavigationLink(
                destination: CalculationPage(
                    user: user,
                    goal: $goal, // ✅ Pass Binding instead of value
                    cost: Double(cost) ?? 0.0,
                    salary: Double(salary) ?? 0.0,
                    savingsType: selectedSavingsType
                ),
                isActive: $navigateToCalculation
            ) { EmptyView() }
            .hidden()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    // ✅ Update goal before navigating
    private func updateGoal() {
        goal.cost = Double(cost) ?? 0.0
        goal.salary = Double(salary) ?? 0.0
        goal.savingsType = selectedSavingsType
    }

    // ✅ Save Goal & Navigate
    private func saveGoal() {
        guard let costValue = Double(cost), costValue > 0,
              let salaryValue = Double(salary), salaryValue > 0 else {
            print("⚠️ Error: Enter valid values before proceeding.")
            return
        }

        updateGoal() // ✅ Update goal before saving

        Task {
            let success = await viewModel.saveGoal(goal: goal)
            DispatchQueue.main.async {
                if success {
                    print("✅ Goal saved successfully: \(goal.name)")

                    Task {
                        await viewModel.saveCalculation(
                            goal: goal,
                            cost: goal.cost,
                            salary: goal.salary,
                            savingsType: goal.savingsType,
                            savingsRequired: 1000
                        )
                    }
                    navigateToCalculation = true // ✅ Navigate after saving
                } else {
                    print("⚠️ Failed to save goal.")
                }
            }
        }
    }

    // ✅ Next Button
    private func nextButton() -> some View {
        Button(action: saveGoal) {
            Text("Next")
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.blue)
                .cornerRadius(25)
        }
        .padding(.top, 20)
    }

    // ✅ Background Gradient
    private func backgroundGradient() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    // ✅ Header View
    private func headerView() -> some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)

            Text("Good evening, \(user.name)")
                .foregroundColor(.white)
                .font(.headline)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 50)
    }

    // ✅ Input Fields
    private func inputFields() -> some View {
        VStack {
            TextField("Set Your Goal Cost", text: $cost)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Enter Your Salary", text: $salary)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}

// ✅ Preview
//struct SetGoalCostView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetGoalCostView(
//            goal: .constant(Goal.defaultGoal()),
//            user: User(id: CKRecord.ID(recordName: UUID().uuidString), name: "Test User")
//        )
//    }
//}

import SwiftUI
import CloudKit
import Foundation

struct CalculationPage: View {
    let user: User
    @Binding var goal: Goal // ✅ Use Binding so it updates correctly
    let cost: Double
    let salary: Double
    let savingsType: Goal.SavingsType

    @StateObject private var viewModel: ViewModel2
    @State private var savingsPerPeriod: Double = 0
    @State private var duration: Int = 0
    @State private var navigateToEdit = false
    @State private var navigateToView3 = false // ✅ Added navigation to View3
    @State private var savingRate: Double = 0.2 // ✅ Default savings rate (20%)

    @Environment(\.presentationMode) var presentationMode

    init(user: User, goal: Binding<Goal>, cost: Double, salary: Double, savingsType: Goal.SavingsType) {
        self.user = user
        self._goal = goal
        self.cost = cost
        self.salary = salary
        self.savingsType = savingsType

        _viewModel = StateObject(wrappedValue: ViewModel2(user: user)) // ✅ Pass correct user
    }

    var body: some View {
        ZStack {
            backgroundGradient()
            
            VStack(spacing: 15) {
                headerView()
                
                VStack(spacing: 15) {
                    inputField(title: "Your \(savingsType.rawValue.capitalized) Payment", value: String(format: "%.2f $", savingsPerPeriod))
                        .overlay(editButton())

                    inputField(title: "Time Needed to Reach Your Goal", value: "\(duration) \(savingsType.rawValue.lowercased())s")
                        .overlay(editButton())
                }
                .frame(width: 380, height: 220)
                .background(RoundedRectangle(cornerRadius: 30).fill(Color(hex: "1C215B")))
                .padding(.horizontal)

                savingsRateSlider()
                
                nextButton() // ✅ Added Next Button to navigate to View3
            }
        }
        .onAppear {
            calculateSavings()
        }
        .onChange(of: savingRate) { _ in
            calculateSavings()
        }
        .background(
            NavigationLink(
                destination: SetGoalCostView(goal: $goal, user: user),
                isActive: $navigateToEdit
            ) { EmptyView() }
            .hidden()
        )
        .background(
            NavigationLink(
                destination: View3(), // ✅ Navigate to View3
                isActive: $navigateToView3
            ) { EmptyView() }
            .hidden()
        )
    }

    // 🔹 **Header View**
    private func headerView() -> some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
            
            Text("Hi, \(user.name)")
                .foregroundColor(.white)
                .font(.headline)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 50)
    }

    // 🔹 **Background Gradient**
    private func backgroundGradient() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    // 🔹 **Input Field**
    private func inputField(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
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
        .padding(.vertical, 5)
    }

    // 🔹 **Edit Button**
    private func editButton() -> some View {
        Button(action: {
            navigateToEdit = true
        }) {
            Image(systemName: "pencil")
                .foregroundColor(.white)
                .padding(10)
        }
        .padding(.trailing, 10)
    }

    // 🔹 **Adjustable Savings Rate Slider**
    private func savingsRateSlider() -> some View {
        VStack {
            Text("Adjust Savings Rate: \(Int(savingRate * 100))%")
                .foregroundColor(.white)
                .font(.headline)
            
            Slider(value: $savingRate, in: 0.05...0.5, step: 0.05)
                .padding(.horizontal)
        }
    }

    // 🔹 **Next Button (Saves Goal and Navigates to View3)**
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
        .padding(.top, 20)
    }

    // 🔹 **Save Goal and Navigate to View3**
    private func saveGoalAndNavigate() {
        goal.cost = cost
        goal.salary = salary
        goal.savingsType = savingsType

        Task {
            let success = await viewModel.saveGoal(goal: goal)
            DispatchQueue.main.async {
                if success {
                    print("✅ Goal confirmed and saved!")
                    navigateToView3 = true
                } else {
                    print("⚠️ Failed to save goal.")
                }
            }
        }
    }

    // 🔹 **Calculation Function**
    private func calculateSavings() {
        guard salary > 0, cost > 0 else {
            savingsPerPeriod = 0
            duration = 0
            return
        }
        
        let savingFactor: Double
        switch savingsType {
        case .daily:
            savingFactor = 30.0
        case .weekly:
            savingFactor = 4.0
        case .monthly:
            savingFactor = 1.0
        }
        
        let calculatedSavingsPerPeriod = (salary * savingRate) / savingFactor
        let calculatedDuration = calculatedSavingsPerPeriod > 0 ? Int(ceil(cost / calculatedSavingsPerPeriod)) : 0
        
        DispatchQueue.main.async {
            self.savingsPerPeriod = calculatedSavingsPerPeriod
            self.duration = max(1, calculatedDuration) // ✅ Ensure at least 1 period
        }
    }
}
//#Preview {
//    CalculationPage(user: User, goal: Goal, cost: Double, salary: Double, savingsType: Goal.SavingsType)
//}

//
//NavigationLink(
//    destination: View3(), // ✅ Navigate to View3
//    isActive: $navigateToView3
//) { EmptyView() }
//.hidden()
//)
//}

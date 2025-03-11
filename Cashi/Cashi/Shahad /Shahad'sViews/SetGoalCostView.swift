import SwiftUI
import CloudKit
import Foundation

struct SetGoalCostView: View {
    let goal: Goal
    let user: User
    
    @State private var name: String
    @State private var cost: String
    @State private var salary: String
    @State private var selectedSavingsType: Goal.SavingsType
    @State private var selectedGoalType: Goal.GoalType
    @State private var imageData: Data?
    @State private var navigateToCalculation = false
    
    @StateObject private var viewModel: ViewModel2
    
    init(goal: Goal, user: User) {
        self.goal = goal
        self.user = user
        _name = State(initialValue: goal.name)
        _cost = State(initialValue: "\(goal.cost)")
        _salary = State(initialValue: "\(goal.salary)")
        _selectedSavingsType = State(initialValue: goal.savingsType)
        _selectedGoalType = State(initialValue: goal.goalType)
        _imageData = State(initialValue: goal.imageData)
        
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
                    
                    goalTypeSelector()
                    
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

            // ✅ حل مشكلة NavigationLink
            NavigationLink(
                destination: CalculationPage(
                    user: user,
                    goal: updatedGoal,
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
    
    private var updatedGoal: Goal {
        let validCost = Double(cost) ?? 0.0
        let validSalary = Double(salary) ?? 0.0
        
        return Goal(
            id: goal.id,
            name: name,
            cost: validCost > 0 ? validCost : 0.0,
            salary: validSalary > 0 ? validSalary : 0.0,
            savingsType: selectedSavingsType,
            emoji: goal.emoji,
            goalType: selectedGoalType,
            imageData: imageData
        )
    }
    
    private func saveGoal() {
        guard let costValue = Double(cost), costValue > 0,
              let salaryValue = Double(salary), salaryValue > 0 else {
            print("⚠️ خطأ: تأكد من إدخال قيمة صحيحة قبل المتابعة")
            return
        }
        
        Task {
            let success = await viewModel.saveGoal(goal: updatedGoal)
            DispatchQueue.main.async {
                if success {
                    print("✅ Goal saved successfully: \(updatedGoal.name)")
                    
                    Task {
                        await viewModel.saveCalculation(
                            goal: updatedGoal,
                            cost: updatedGoal.cost,
                            salary: updatedGoal.salary,
                            savingsType: updatedGoal.savingsType,
                            savingsRequired: 1000
                        )
                    }
                    navigateToCalculation = true
                } else {
                    print("⚠️ فشل حفظ الهدف.")
                }
            }
        }
    }

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

    private func goalTypeSelector() -> some View {
        HStack {
            ForEach(Goal.GoalType.allCases, id: \.self) { type in
                Text(type.rawValue.capitalized)
                    .foregroundColor(selectedGoalType == type ? .white : .gray)
                    .padding()
                    .background(selectedGoalType == type ? Color(hex: "160158") : Color.clear)
                    .clipShape(Capsule())
                    .onTapGesture { selectedGoalType = type }
            }
        }
    }

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


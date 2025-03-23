import SwiftUI
import CloudKit

struct SetGoalCostView: View {
    @Binding var goal: Goal
    let user: User
    

    @State private var cost: String
    @State private var selectedSavingsType: Goal.SavingsType
    @State private var selectedGoalType: Goal.GoalType = .individual
    @State private var navigateToCalculation = false

    @StateObject private var viewModel: ViewModel2

    init(goal: Binding<Goal>, user: User) {
        self._goal = goal
        self.user = user
        _cost = State(initialValue: "\(goal.wrappedValue.cost)")
        _selectedSavingsType = State(initialValue: goal.wrappedValue.savingsType)
        _viewModel = StateObject(wrappedValue: ViewModel2(user: user))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient()
                    .ignoresSafeArea()

                VStack {
                    headerView()
                    
                    Spacer(minLength: 80) // ✅ زيادة المسافة بين البروفايل والمربع

                    VStack(spacing: 25) {
                        timePeriodSelection()
                        goalTypeSelection()
                        goalCostInput()
                    }
                    .frame(width: 400, height: 400) // ✅ تعديل الحجم كما طلبت
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "243470"), Color(hex: "1C215B"), Color(hex: "120248")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomLeading
                                )
                            )
                    )
                    .padding(.horizontal)

                    Spacer()

                    nextButton()
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

            NavigationLink(
                destination: CalculationPage(
                    user: user,
                    goal: $goal,
                    cost: Double(cost) ?? 0.0,
                    savingsType: selectedSavingsType
                ),
                isActive: $navigateToCalculation
            ) { EmptyView() }
            .hidden()
        }
    }

    // ✅ **الخلفية مع تدرج مطابق**
    private func backgroundGradient() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1F0179"), Color(hex: "160158"), Color(hex: "0E0137")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // ✅ **الهيدر**
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
        .padding(.leading, 20)
        .padding(.bottom, 100)
    }

    // ✅ **اختيار مدة الادخار مطابق للصورة**
    private func timePeriodSelection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Choose Your Time Period")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
                .padding(.leading, 10)

            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: "160158"))
                    .frame(height: 50) // ✅ ضبط ارتفاع المستطيل الخلفي

                HStack(spacing: 5) { // ✅ ضبط المسافة بين الأزرار
                    ForEach([Goal.SavingsType.daily, .weekly, .monthly], id: \.self) { type in
                        Text(type.rawValue.capitalized)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(selectedSavingsType == type ? .white : Color.gray.opacity(0.6))
                            .frame(width: 85, height: 35) // ✅ ضبط الأزرار لتكون متناسقة تمامًا
                            .background(
                                Capsule()
                                    .fill(selectedSavingsType == type ? Color(hex: "2A1179") : Color.clear)
                            )
                            .onTapGesture {
                                selectedSavingsType = type
                            }
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .padding(.horizontal, 20)
    }

    // ✅ **اختيار نوع الهدف مطابق تمامًا للصورة**
    private func goalTypeSelection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Choose Your Goal Type")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
                .padding(.leading, 10)

            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: "160158"))
                    .frame(height: 50) // ✅ نفس ارتفاع المستطيل كما في timePeriodSelection

                HStack(spacing: 5) { // ✅ نفس المسافات بين الأزرار
                    ForEach([Goal.GoalType.qattah, .individual, .challenge], id: \.self) { type in
                        Text(type.rawValue.capitalized)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(selectedGoalType == type ? .white : Color.gray.opacity(0.6))
                            .frame(width: 110, height: 35) // ✅ نفس أبعاد الأزرار كما في timePeriodSelection
                            .background(
                                Capsule()
                                    .fill(selectedGoalType == type ? Color(hex: "2A1179") : Color.clear)
                            )
                            .onTapGesture {
                                selectedGoalType = type
                            }
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .padding(.horizontal, 20)
    }
    // ✅ **إدخال تكلفة الهدف**
    private func goalCostInput() -> some View {
        VStack(alignment: .leading) {
            Text("Set Your Goal Cost")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 20)

            TextField("Set Your Goal Cost", text: $cost)
                .keyboardType(.decimalPad)
                .padding()
                .foregroundColor(.white) // ✅ Ensures the input text is white
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                )
                .accentColor(.white) // ✅ Ensures the cursor is white
                .padding(.horizontal, 20)
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
        .padding(.top, 30)
        .padding(.leading,200)
    }
    
    // ✅ **حفظ البيانات مع التنقل**
    private func saveGoal() {
        guard let costValue = Double(cost), costValue > 0 else {
            print("⚠️ Error: Enter valid values before proceeding.")
            return
        }

        goal.cost = costValue
        goal.salary = user.salary
        goal.savingsType = selectedSavingsType
        goal.goalType = selectedGoalType

        Task {
            let success = await viewModel.saveGoal(goal: goal)
            DispatchQueue.main.async {
                if success {
                    print("✅ Goal saved successfully!")
                    navigateToCalculation = true
                } else {
                    print("⚠️ Failed to save goal.")
                }
            }
        }
    }
}


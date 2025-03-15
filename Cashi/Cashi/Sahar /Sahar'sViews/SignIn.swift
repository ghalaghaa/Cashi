import SwiftUI
import CloudKit

class WelcomeGoalsViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var income: String = ""
    @Published var isNameValid: Bool = false
    @Published var isIncomeValid: Bool = false

    func validateName() {
        isNameValid = !name.isEmpty
    }

    func validateIncome() {
        isIncomeValid = !income.isEmpty
    }

    func nextButtonTapped() {
        print("Next button tapped. Name: \(name), Income: \(income)")
        // Add any further logic here, like saving to CloudKit or navigating to the next screen.
    }

    func filterIncomeInput(_ newValue: String) {
        let filtered = newValue.filter { "0123456789".contains($0) }
        if filtered != newValue {
            income = filtered
        }
        validateIncome()
    }
}

struct GoalsW: View {
    @StateObject private var viewModel = WelcomeGoalsViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.2, green: 0.2, blue: 0.5)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {}) {}
                        .padding(.trailing, -90)
                }
                .padding(.bottom, -90)

                VStack {
                    Spacer()

                    Text("Welcome,\nGlad to see you!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50)

                    VStack(alignment: .leading) {
                        Text("Name")
                            .foregroundColor(.white)
                            .padding(.leading)
                        HStack {
                            TextField("Name", text: $viewModel.name)
                                .foregroundColor(.white)
                                .padding(.leading, 35)
                                .frame(width: 325, height: 51, alignment: .leading)
                                .background(Color(red: 0.12, green: 0.04, blue: 0.39))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .inset(by: 0.35)
                                        .stroke(Color(red: 0.24, green: 0.43, blue: 0.78), lineWidth: 0.7)
                                )
                                .onChange(of: viewModel.name) { _ in
                                    viewModel.validateName()
                                }

                            if viewModel.isNameValid {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else if viewModel.name.isEmpty {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.trailing, 10)
                    }

                    VStack(alignment: .leading) {
                        Text("Income")
                            .foregroundColor(.white)
                            .font(Font.custom("SF Pro Display", size: 16))
                            .kerning(0.374)
                            .foregroundColor(Color(red: 0.4, green: 0.5, blue: 0.76))
                        HStack {
                            TextField("Income", text: $viewModel.income)
                                .foregroundColor(.white)
                                .padding(.leading, 35)
                                .frame(width: 325, height: 51, alignment: .leading)
                                .background(Color(red: 0.12, green: 0.04, blue: 0.39))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .inset(by: 0.35)
                                        .stroke(Color(red: 0.2, green: 0.4, blue: 0.7), lineWidth: 0.7)
                                )
                                .onChange(of: viewModel.income) { newValue in
                                    viewModel.filterIncomeInput(newValue)
                                }

                            if viewModel.isIncomeValid {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else if viewModel.income.isEmpty {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.trailing, 10)
                    }

                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.nextButtonTapped()
                        }) {
                            Text("Next")
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.trailing, 12)
                    }
                    .padding(.bottom)
                }
                .frame(width: 400, height: 845)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.1, green: 0.42, blue: 0.57), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.1, green: 0, blue: 0.35), location: 0.1),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.4, y: 1)
                    )
                )
                .cornerRadius(30)
            }
        }
    }
}

struct GoalsW_Previews: PreviewProvider {
    static var previews: some View {
        GoalsW()
    }
}

//
//  LogInView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 16/03/1446 AH.
//

import SwiftUI
import CloudKit

// MARK: - ViewModel
class WelcomeGoalsViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var income: String = ""
    @Published var isNameValid: Bool = false
    @Published var isIncomeValid: Bool = false
    @Published var isSaved: Bool = false
    @Published var showiCloudAlert: Bool = false

    func validateName() {
        isNameValid = !name.isEmpty
    }

    func validateIncome() {
        isIncomeValid = !income.isEmpty
    }

    func filterIncomeInput(_ newValue: String) {
        let filtered = newValue.filter { "0123456789".contains($0) }
        if filtered != newValue {
            income = filtered
        }
        validateIncome()
    }

    // تحقق من حالة iCloud قبل الحفظ
    func checkiCloudStatusAndSave(appleEmail: String) {
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async {
                switch status {
                case .available:
                    self.saveToCloudKit(appleEmail: appleEmail)
                default:
                    self.showiCloudAlert = true
                }
            }
        }
    }

    // حفظ أو تحديث السجل بناءً على الإيميل فقط
    func saveToCloudKit(appleEmail: String) {
        let container = CKContainer(identifier: "iCloud.CashiBackup")
        let publicDB = container.publicCloudDatabase

        let predicate = NSPredicate(format: "email == %@", appleEmail)
        let query = CKQuery(recordType: "ADDUsers", predicate: predicate)

        publicDB.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                    return
                }

                if let record = records?.first {
                    // تحديث السجل الحالي
                    record["name"] = self.name
                    record["income"] = self.income

                    publicDB.save(record) { _, error in
                        DispatchQueue.main.async {
                            self.isSaved = (error == nil)
                        }
                    }
                } else {
                    // إنشاء سجل جديد
                    let newRecord = CKRecord(recordType: "ADDUsers")
                    newRecord["name"] = self.name
                    newRecord["income"] = self.income
                    newRecord["email"] = appleEmail

                    publicDB.save(newRecord) { _, error in
                        DispatchQueue.main.async {
                            self.isSaved = (error == nil)
                        }
                    }
                }
            }
        }
    }
}
// MARK: - View
struct GoalsW: View {
    var appleEmail: String
    @StateObject private var viewModel = WelcomeGoalsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.2, green: 0.2, blue: 0.5)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

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
                                .frame(width: 325, height: 51)
                                .background(Color(red: 0.12, green: 0.04, blue: 0.39))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(red: 0.24, green: 0.43, blue: 0.78), lineWidth: 0.7)
                                )
                                .onChange(of: viewModel.name) { _ in
                                    viewModel.validateName()
                                }

                            if viewModel.isNameValid {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            } else if viewModel.name.isEmpty {
                                Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                            }
                        }.padding(.trailing, 10)
                    }

                    VStack(alignment: .leading) {
                        Text("Income").foregroundColor(.white)
                        HStack {
                            TextField("Income", text: $viewModel.income)
                                .foregroundColor(.white)
                                .padding(.leading, 35)
                                .frame(width: 325, height: 51)
                                .background(Color(red: 0.12, green: 0.04, blue: 0.39))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(red: 0.2, green: 0.4, blue: 0.7), lineWidth: 0.7)
                                )
                                .onChange(of: viewModel.income) { newValue in
                                    viewModel.filterIncomeInput(newValue)
                                }

                            if viewModel.isIncomeValid {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            } else if viewModel.income.isEmpty {
                                Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                            }
                        }.padding(.trailing, 10)
                    }

                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.checkiCloudStatusAndSave(appleEmail: appleEmail)
                        }) {
                            Text("Next")
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .alert("iCloud is not available", isPresented: $viewModel.showiCloudAlert) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text("Please make sure you are signed in to iCloud before proceeding.")
                        }
                        .padding(.trailing, 12)

                        NavigationLink(destination: GoalSelectionView(), isActive: $viewModel.isSaved) {
                            EmptyView()
                        }.hidden()
                    }
                    .padding(.bottom)
                }
                .frame(width: 400, height: 845)
                .cornerRadius(30)
            }
        }
    }
}
struct GoalsW_Previews: PreviewProvider {
    static var previews: some View {
        GoalsW(appleEmail: "test@example.com")
    }
}

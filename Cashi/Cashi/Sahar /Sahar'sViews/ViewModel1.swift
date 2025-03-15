//import SwiftUI
//
//struct NameIncomeView: View {
//    @State private var name: String = ""
//    @State private var income: String = ""
//    @State private var isNameValid: Bool = false
//    @State private var isIncomeValid: Bool = false
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            Text("Name")
//                .foregroundColor(.white)
//                .padding(.leading)
//
//            HStack {
//                TextField("Name", text: $name)
//                    .padding()
//                    .background(Color(red: 0.12, green: 0.04, blue: 0.39))
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .onChange(of: name) { newValue in
//                        isNameValid = !newValue.isEmpty
//                    }
//
//                if isNameValid {
//                    Image(systemName: "checkmark.circle.fill")
//                        .foregroundColor(.green)
//                } else if name.isEmpty { // Show red mark if empty
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.red)
//                }
//            }
//            .padding(.trailing, 10) // Add padding to the HStack
//
//            Text("Income")
//                .foregroundColor(.white)
//                .padding(.leading)
//
//            HStack {
//                TextField("Income", text: $income)
//                    .padding()
//                    .background(Color(red: 0.12, green: 0.04, blue: 0.39))
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .onChange(of: income) { newValue in
//                        isIncomeValid = !newValue.isEmpty
//                    }
//
//                if isIncomeValid {
//                    Image(systemName: "checkmark.circle.fill")
//                        .foregroundColor(.green)
//                } else if income.isEmpty { // Show red mark if empty
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.red)
//                }
//            }
//            .padding(.trailing, 10) // Add padding to the HStack
//
//            Spacer()
//        }
//        .padding()
//        .background(Color(red: 0.1, green: 0.1, blue: 0.3))
//        .edgesIgnoringSafeArea(.all)
//    }
//}
//
//struct NameIncomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NameIncomeView()
//    }
//}

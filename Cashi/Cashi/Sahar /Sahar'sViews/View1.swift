////
////  ContentView.swift
////  Cashi
////
////  Created by Ghala Alnemari on 24/08/1446 AH.
////
//
//import SwiftUI
//import CloudKit
//
//struct LoginView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var isLoading: Bool = false
//    @State private var errorMessage: String?
//
//    var body: some View {
//        VStack {
//            Text("Login")
//                .font(.largeTitle)
//                .bold()
//                .padding(.bottom, 20)
//
//            TextField("Email", text: $email)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//                .autocapitalization(.none)
//
//            SecureField("Password", text: $password)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            if let error = errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//                    .font(.caption)
//            }
//
//            Button(action: loginUser) {
//                if isLoading {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                } else {
//                    Text("Login")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//            }
//            .disabled(isLoading)
//            .padding()
//        }
//        .padding()
//    }
//
//    private func loginUser() {
//        isLoading = true
//        errorMessage = nil
//        
//        let predicate = NSPredicate(format: "email == %@", email)
//        // يجب إضافة منطق تسجيل الدخول هنا
//    }
//}
//Button(action: loginUser) {
//    if isLoading {
//        ProgressView()
//            .progressViewStyle(CircularProgressViewStyle(tint: .white))
//    } else {
//        Text("Login")
//            .font(.headline)
//            .foregroundColor(.white)
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(Color.blue)
//            .cornerRadius(10)
//    }
//}
//.disabled(isLoading)
//.padding()
//
//private func loginUser() {
//    isLoading = true
//    errorMessage = nil
//
//    let predicate = NSPredicate(format: "email == %@", email)
//    let query = CKQuery(recordType: "Users", predicate: predicate)
//    let database = CKContainer(identifier: "iCloud.CashiBackup").publicCloudDatabase
//
//    database.perform(query, inZoneWith: nil) { results, error in
//        DispatchQueue.main.async {
//            isLoading = false
//            if let error = error {
//                errorMessage = "Error: \(error.localizedDescription)"
//                return
//            }
//
//            guard let userRecord = results?.first,
//                  let storedPassword = userRecord["password"] as? String,
//                  storedPassword == password else {
//                errorMessage = "Invalid email or password."
//                return
//            }
//
//            print("✅ Login successful for user: \(email)")
//        }
//    }
//}
//
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
//
//

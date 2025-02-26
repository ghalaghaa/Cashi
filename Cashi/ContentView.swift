//
//  ContentView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @StateObject private var model = Model.current
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isLoading = false
    @State private var saveStatus: String = ""
    @State private var fetchStatus: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("إضافة مستخدم جديد")) {
                        TextField("الاسم", text: $name)
                        TextField("البريد الإلكتروني", text: $email)
                        Button(action: addUser) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                }
                                Text("إضافة المستخدم")
                            }
                        }
                        .disabled(name.isEmpty || email.isEmpty || isLoading)
                        Text(saveStatus).foregroundColor(.blue)
                    }
                    
                    Section(header: Text("المستخدمون")) {
                        if model.users.isEmpty {
                            Text("لا يوجد مستخدمون").foregroundColor(.gray)
                        } else {
                            List(model.users, id: \ .id) { user in
                                HStack {
                                    if let profilePicture = user.profilePicture,
                                       let imageData = try? Data(contentsOf: profilePicture.fileURL!),
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                    }
                                    VStack(alignment: .leading) {
                                        Text(user.name).font(.headline)
                                        Text(user.email).font(.subheadline).foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        Text(fetchStatus).foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("CloudKit Users")
            .onAppear {
                Task {
                    do {
                        try await model.fetchUsers()
                        fetchStatus = "تم جلب المستخدمين بنجاح ✅"
                    } catch {
                        fetchStatus = "خطأ في جلب المستخدمين ❌: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    private func addUser() {
        isLoading = true
        saveStatus = "جاري حفظ المستخدم..."
        Task {
            do {
                try await model.addUser(name: name, email: email, profileImage: nil)
                name = ""
                email = ""
                saveStatus = "تم حفظ المستخدم بنجاح ✅"
                try await model.fetchUsers()
                fetchStatus = "تم جلب المستخدمين بعد الإضافة ✅"
            } catch {
                saveStatus = "خطأ في الإضافة ❌: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

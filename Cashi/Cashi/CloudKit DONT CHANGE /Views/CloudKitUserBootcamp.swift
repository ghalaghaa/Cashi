//
//  LogInView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 16/03/1446 AH.
//

import SwiftUI
import CloudKit

struct CloudKitUserView: View {
    @StateObject private var vm = CloudKitUserViewModel()
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var saveStatus: String = ""

    // تسجيل الدخول
    @State private var loginEmail: String = ""
    @State private var loginStatus: String = ""

    // التنقل بعد تسجيل الدخول
    @State private var navigateToAddFriends: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("هل المستخدم مسجل في iCloud؟")
                    .font(.headline)

                Text(vm.isSignedInToiCloud ? "✅ نعم" : "❌ لا")
                    .font(.title)
                    .foregroundColor(vm.isSignedInToiCloud ? .green : .red)

                if !vm.error.isEmpty {
                    Text("⚠️ خطأ: \(vm.error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("name: \(vm.userName)")
                }

                Form {
                    // تسجيل الدخول
                    Section(header: Text("تسجيل الدخول")) {
                        TextField("البريد الإلكتروني", text: $loginEmail)
                            .keyboardType(.emailAddress)

                        Button("تسجيل الدخول") {
                            loginUser()
                        }
                        .disabled(loginEmail.isEmpty)

                        Text(loginStatus)
                            .foregroundColor(loginStatus.contains("✅") ? .green : .red)
                            .font(.footnote)

                        // التنقل التلقائي بعد تسجيل الدخول
                        NavigationLink(destination: IncomingRequestsView(), isActive: $navigateToAddFriends) {
                            EmptyView()
                        }
                        .hidden()
                    }

                    // إضافة مستخدم جديد
                    Section(header: Text("إضافة مستخدم جديد")) {
                        TextField("الاسم", text: $name)
                        TextField("البريد الإلكتروني", text: $email)
                            .keyboardType(.emailAddress)

                        Button(action: addUser) {
                            Text("إضافة المستخدم")
                        }
                        .disabled(name.isEmpty || email.isEmpty)

                        Text(saveStatus).foregroundColor(.blue)
                    }

                    // قائمة المستخدمين
                    Section(header: Text("المستخدمون")) {
                        if vm.users.isEmpty {
                            Text("لا يوجد مستخدمون").foregroundColor(.gray)
                        } else {
                            List(vm.users, id: \.id) { user in
                                VStack(alignment: .leading) {
                                    Text(user.name).font(.headline)
                                    Text(user.email).font(.subheadline).foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                Task {
                    do {
                        try await vm.fetchUsers()
                    } catch {
                        print("❌ فشل في جلب المستخدمين: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    // MARK: - إضافة مستخدم
    private func addUser() {
        saveStatus = "جاري حفظ المستخدم..."
        Task {
            do {
                try await vm.addUser(name: name, email: email)
                name = ""
                email = ""
                saveStatus = "✅ تم حفظ المستخدم بنجاح"
                try await vm.fetchUsers()
            } catch {
                saveStatus = "❌ خطأ في الإضافة: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - تسجيل الدخول
    private func loginUser() {
        vm.assignCurrentUser(by: loginEmail)
        if vm.currentUser != nil {
            loginStatus = "✅ تم تسجيل الدخول بنجاح"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                navigateToAddFriends = true
            }
        } else {
            loginStatus = "❌ المستخدم غير موجود"
        }
    }
}
#Preview {
    CloudKitUserView()
}

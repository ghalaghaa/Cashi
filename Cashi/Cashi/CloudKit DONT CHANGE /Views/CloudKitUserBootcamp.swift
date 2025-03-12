

import SwiftUI
import CloudKit

struct CloudKitUserView: View {
    @StateObject private var vm = CloudKitUserViewModel()
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var saveStatus: String = ""

    var body: some View {
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
                Section(header: Text("إضافة مستخدم جديد")) {
                    TextField("الاسم", text: $name)
                    TextField("البريد الإلكتروني", text: $email)
                    Button(action: addUser) {
                        Text("إضافة المستخدم")
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                    Text(saveStatus).foregroundColor(.blue)
                }

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
                    print("🔍 محاولة جلب المستخدمين من CloudKit...")
                    try await vm.fetchUsers()
                } catch {
                    print("❌ فشل في جلب المستخدمين: \(error.localizedDescription)")
                }
            }
        }
    }

    private func addUser() {
        saveStatus = "جاري حفظ المستخدم..."
        Task {
            do {
                print("📝 محاولة حفظ المستخدم: الاسم = \(name), البريد = \(email)")
                try await vm.addUser(name: name, email: email)
                name = ""
                email = ""
                saveStatus = "تم حفظ المستخدم بنجاح ✅"
                print("✅ المستخدم تم حفظه بنجاح!")

                print("🔄 تحديث قائمة المستخدمين...")
                try await vm.fetchUsers()
            } catch {
                saveStatus = "❌ خطأ في الإضافة: \(error.localizedDescription)"
                print("❌ فشل في حفظ المستخدم: \(error.localizedDescription)")
            }
        }
    }
}
#Preview {
    CloudKitUserView()
}

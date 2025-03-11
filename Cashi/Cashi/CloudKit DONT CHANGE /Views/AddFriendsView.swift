//
//  AddFriendsView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 10/09/1446 AH.
//

import SwiftUI
import CloudKit

struct AddFriendsView: View {
    @StateObject private var userVM = CloudKitUserViewModel()
    @State private var statusMessage: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("👥 إضافة الأصدقاء")
                    .font(.title)
                    .bold()

                if userVM.users.isEmpty {
                    Text("لا يوجد مستخدمون لعرضهم").foregroundColor(.gray)
                } else {
                    List(userVM.users, id: \.id) { user in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(user.name).font(.headline)
                            Text(user.email).font(.caption).foregroundColor(.gray)

                            Button(action: {
                                sendFriendRequest(to: user)
                            }) {
                                Text("➕ إضافة كصديق")
                                    .font(.subheadline)
                                    .padding(6)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                if !statusMessage.isEmpty {
                    Text(statusMessage)
                        .font(.footnote)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
            .onAppear {
                Task {
                    do {
                        try await userVM.fetchUsers()
                    } catch {
                        statusMessage = "❌ فشل تحميل المستخدمين: \(error.localizedDescription)"
                    }
                }
            }
            .navigationBarTitle("إضافة الأصدقاء", displayMode: .inline)
        }
    }

    func sendFriendRequest(to user: User) {
        guard let currentUser = userVM.currentUser else {
            statusMessage = "❌ لا يوجد مستخدم حالي"
            return
        }

        // لا ترسل لنفسك
        if user.id == currentUser.id {
            statusMessage = "⚠️ لا يمكنك إرسال طلب صداقة لنفسك"
            return
        }

        FriendRequestManager.shared.sendFriendRequest(to: user, from: currentUser) { result in
            switch result {
            case .success():
                statusMessage = "✅ تم إرسال الطلب إلى \(user.name)"
            case .failure(let error):
                statusMessage = "❌ فشل إرسال الطلب: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    AddFriendsView()
}

//
//  IncomingRequestsView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 10/09/1446 AH.
//

import SwiftUI
import CloudKit

struct IncomingRequestsView: View {
    @State private var incomingRequests: [FriendRequest] = []
    @StateObject private var userVM = CloudKitUserViewModel()
    
    // ✅ تخزين أسماء المرسلين
    @State private var senderNames: [CKRecord.ID: String] = [:]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("📩 الطلبات الواردة")
                .font(.title2)
                .bold()
            
            if incomingRequests.isEmpty {
                Text("لا توجد طلبات حالياً")
                    .foregroundColor(.gray)
            } else {
                List(incomingRequests, id: \.id) { request in
                    VStack(alignment: .leading, spacing: 8) {
                        // ✅ عرض اسم المرسل بدل recordID
                        Text("طلب من: \(senderNames[request.senderID.recordID] ?? "جاري التحميل...")")
                        
                        Text("الحالة: \(request.status)")
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        HStack(spacing: 20) {
                            Button("✅ قبول") {
                                updateStatus(request, to: "accepted")
                            }
                            Button("❌ رفض") {
                                updateStatus(request, to: "rejected")
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Divider().padding(.vertical, 10)
            
            // ✅ قسم الأصدقاء المضافين
            Text("👥 الأصدقاء المضافين")
                .font(.title3)
                .bold()
            
            if userVM.friends.isEmpty {
                Text("لا يوجد أصدقاء حالياً")
                    .foregroundColor(.gray)
            } else {
                List(userVM.friends, id: \.id) { friend in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(friend.name)
                            .font(.headline)
                        Text(friend.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxHeight: 250)
            }
        }
        .padding()
        .onAppear {
            Task {
                await loadCurrentUserAndFetchRequests()
            }
        }
    }
    
    // MARK: - Load current user & fetch requests
    func loadCurrentUserAndFetchRequests() async {
        do {
            try await userVM.fetchUsers()
            print("📌 currentUser id: \(userVM.currentUser?.id.recordName ?? "❌ غير موجود")")
            guard let currentUser = userVM.currentUser else {
                print("⚠️ لم يتم العثور على مستخدم حالي")
                return
            }
            FriendRequestManager.shared.fetchIncomingFriendRequests(for: currentUser) { requests in
                self.incomingRequests = requests
                print("📥 تم جلب \(requests.count) طلب وارد")
                
                // ✅ جلب أسماء المرسلين
                for request in requests {
                    let senderID = request.senderID.recordID
                    if self.senderNames[senderID] == nil {
                        Task {
                            do {
                                let senderRecord = try await userVM.fetchUserRecord(by: senderID)
                                let name = senderRecord["name"] as? String ?? "غير معروف"
                                DispatchQueue.main.async {
                                    self.senderNames[senderID] = name
                                }
                            } catch {
                                print("❌ فشل في جلب اسم المرسل: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            await userVM.fetchFriends(for: currentUser)
        } catch {
            print("❌ فشل تحميل المستخدمين: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch Requests
    func fetchRequests() {
        guard let currentUser = userVM.currentUser else {
            print("⚠️ لا يوجد مستخدم حالي")
            return
        }
        
        FriendRequestManager.shared.fetchIncomingFriendRequests(for: currentUser) { requests in
            self.incomingRequests = requests
            print("📥 تم جلب \(requests.count) طلب وارد")
        }
    }

    // MARK: - Update Status
    func updateStatus(_ request: FriendRequest, to status: String) {
        FriendRequestManager.shared.updateFriendRequestStatus(request, newStatus: status) { result in
            switch result {
            case .success():
                print("✅ تم تحديث الحالة إلى: \(status)")
                fetchRequests()
                Task {
                    if let current = userVM.currentUser {
                        await userVM.fetchFriends(for: current)
                    }
                }
            case .failure(let error):
                print("❌ خطأ أثناء التحديث: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    IncomingRequestsView()
}

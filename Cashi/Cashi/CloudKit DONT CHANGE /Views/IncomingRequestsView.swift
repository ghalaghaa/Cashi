//
//  IncomingRequestsView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 10/09/1446 AH.
//

import SwiftUI

struct IncomingRequestsView: View {
    @State private var incomingRequests: [FriendRequest] = []
    @StateObject private var userVM = CloudKitUserViewModel()

    var body: some View {
        VStack {
            Text("📩 الطلبات الواردة")
                .font(.title2)
                .bold()

            if incomingRequests.isEmpty {
                Text("لا توجد طلبات حالياً")
                    .foregroundColor(.gray)
            } else {
                List(incomingRequests, id: \.id) { request in
                    VStack(alignment: .leading) {
                        Text("طلب من: \(request.senderID.recordID.recordName)")
                        Text("الحالة: \(request.status)")
                            .font(.caption)
                            .foregroundColor(.blue)

                        HStack {
                            Button("✅ قبول") {
                                updateStatus(request, to: "accepted")
                            }
                            Button("❌ رفض") {
                                updateStatus(request, to: "rejected")
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            fetchRequests()
        }
    }

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

    func updateStatus(_ request: FriendRequest, to status: String) {
        FriendRequestManager.shared.updateFriendRequestStatus(request, newStatus: status) { result in
            switch result {
            case .success():
                print("✅ تم تحديث الحالة إلى: \(status)")
                fetchRequests()
            case .failure(let error):
                print("❌ خطأ أثناء التحديث: \(error.localizedDescription)")
            }
        }
    }
}
#Preview {
    IncomingRequestsView()
}

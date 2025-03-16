//
//  ChallengeGoalsView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 12/09/1446 AH.
//

import SwiftUI
import CloudKit

struct ProgressSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var amountText: String = ""
    @State private var showSelectFriendsView = false
    @State private var acceptedParticipants: [String] = []
    @State private var currentUserRef: CKRecord.Reference?
    
    // ✅ استقبل المستخدم الحالي واسم التحدي من الشاشة السابقة
    var currentUser: User
    var challengeName: String

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "24326D"), Color(hex: "160158")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Edit Your Progress")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 16)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Amount")
                        .foregroundColor(.white)
                        .font(.callout)

                    TextField("Enter amount...", text: $amountText)
                        .padding()
                        .background(Color(hex: "160158"))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal, 24)

                Text("Your Friends Progress")
                    .font(.headline)
                    .foregroundColor(.white)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(acceptedParticipants, id: \.self) { participant in
                            VStack(spacing: 6) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 80, height: 120)

                                    ZStack(alignment: .bottom) {
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                                startPoint: .bottom,
                                                endPoint: .top))
                                            .frame(height: 60)
                                            .clipShape(RoundedRectangle(cornerRadius: 40))
                                    }
                                    .frame(width: 80, height: 120)

                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.blue, lineWidth: 2)
                                        .frame(width: 80, height: 120)

                                    VStack(spacing: 4) {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 35, height: 35)
                                            .foregroundColor(.white)

                                        Text("50%")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                    }
                                }
                                Text(participant)
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                        }

                        // زر إضافة صديق
                        VStack(spacing: 6) {
                            Button(action: {
                                showSelectFriendsView = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 80, height: 120)

                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.blue, lineWidth: 2)
                                        .frame(width: 80, height: 120)

                                    Image(systemName: "plus")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.blue)
                                }
                            }

                            Text("Add Friend")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Next")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 16)
                }
            }
            .frame(maxHeight: .infinity)
            .onAppear {
                fetchAcceptedParticipants()
            }
        }
        // ✅ فتح شاشة اختيار الأصدقاء بدل IncomingRequestsView
        .fullScreenCover(isPresented: $showSelectFriendsView) {
//            SelectFriendsForChallengeView(
//                currentUser: currentUser,
//                challengeName: challengeName
            ADFriendsView()

            
        }
    }

    func fetchAcceptedParticipants() {
        guard let currentUserRef = currentUserRef else { return }

        ChallengeJoinRequestManager.shared.fetchIncomingRequests(for: currentUserRef) { requests in
            let accepted = requests.filter { $0.status == "accepted" }

            var names: [String] = []
            let group = DispatchGroup()

            for request in accepted {
                group.enter()
                let senderRecordID = request.senderID.recordID
                let recordFetch = CKFetchRecordsOperation(recordIDs: [senderRecordID])
                recordFetch.perRecordResultBlock = { recordID, result in
                    switch result {
                    case .success(let record):
                        let name = record["name"] as? String ?? "Unknown"
                        names.append(name)
                    case .failure(_):
                        names.append("Unknown")
                    }
                    group.leave()
                }

                CKContainer.default().publicCloudDatabase.add(recordFetch)
            }

            group.notify(queue: .main) {
                self.acceptedParticipants = names
            }
        }
    }
}

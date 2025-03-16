//
//  LogInView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 16/03/1446 AH.
//



import SwiftUI
import CloudKit

struct SelectFriendsForChallengeView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var userVM = CloudKitUserViewModel()
    @State private var selectedFriends: [CKRecord.ID] = []
    
    var currentUser: User
    var challengeName: String
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Choose Friends to Join")
                    .font(.title2)
                    .bold()
                    .padding(.top, 16)
                
                if userVM.friends.isEmpty {
                    Text("No friends available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(userVM.friends, id: \.id) { friend in
                            HStack {
                                Text(friend.name)
                                Spacer()
                                if selectedFriends.contains(friend.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.gray)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleSelection(for: friend.id)
                            }
                        }
                    }
                }
                
                Button(action: {
                    print("🔘 Send Invitation Button Pressed")
                    sendChallengeRequests()
                }) {
                    Text("Send Invitation")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 16)
            }
            .onAppear {
                print("📥 onAppear - Preparing to fetch users and friends...")
                Task {
                    do {
                        try await userVM.fetchUsers()
                        print("✅ Users fetched: \(userVM.users.count)")
                        
                        await userVM.fetchFriends(for: currentUser)
                        print("✅ Friends fetched: \(userVM.friends.count)")
                    } catch {
                        print("❌ Error fetching users: \(error.localizedDescription)")
                    }
                }
            }
            .navigationTitle("Invite Friends")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        print("🔙 Dismiss SelectFriendsForChallengeView")
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func toggleSelection(for friendID: CKRecord.ID) {
        if friendID == currentUser.id {
            print("⚠️ You cannot send a challenge to yourself")
            return
        }

        if let index = selectedFriends.firstIndex(of: friendID) {
            selectedFriends.remove(at: index)
            print("❎ Deselected Friend ID: \(friendID.recordName)")
        } else {
            selectedFriends.append(friendID)
            print("✅ Selected Friend ID: \(friendID.recordName)")
        }
    }
    
    private func sendChallengeRequests() {
        guard !selectedFriends.isEmpty else {
            print("⚠️ No friends selected to send requests")
            return
        }

        for friendID in selectedFriends {
            let friendRef = CKRecord.Reference(recordID: friendID, action: .none)
            let senderRef = CKRecord.Reference(recordID: currentUser.id, action: .none)
            
            print("📤 Sending request → Challenge: \(challengeName), From: \(senderRef.recordID.recordName), To: \(friendID.recordName)")
            
            ChallengeJoinRequestManager.shared.sendRequest(
                challengeName: challengeName,
                senderID: senderRef,
                receiverID: friendRef
            ) { result in
                switch result {
                case .success():
                    print("✅ Successfully sent request to: \(friendID.recordName)")
                case .failure(let error):
                    print("❌ Failed to send request to \(friendID.recordName): \(error.localizedDescription)")
                }
            }
        }
        
        print("📦 All requests sent, dismissing view")
        dismiss()
    }
}

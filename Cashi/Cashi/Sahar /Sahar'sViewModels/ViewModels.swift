
import SwiftUI
import CloudKit
import AuthenticationServices

class LogInViewModel: ObservableObject {
    @Published var isActive = false
    @Published var errorMessage: String?
    @Published var isLoading = false

    func handleSignInWithApple(credential: ASAuthorizationAppleIDCredential) {
        let userId = credential.user.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !userId.isEmpty else {
            errorMessage = "Invalid user ID from Apple."
            return
        }

        let container = CKContainer.default()
        let database = container.publicCloudDatabase

        let userRecord = CKRecord(recordType: "User", recordID: CKRecord.ID(recordName: userId))
        userRecord["userId"] = userId as CKRecordValue

        isLoading = true

        database.save(userRecord) { record, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Failed to save user record: \(error.localizedDescription)"
                } else {
                    self.isActive = true
                }
            }
        }
    }

    func signInWithAppleCompletion(result: Result<ASAuthorizationAppleIDCredential, Error>) {
        switch result {
        case .success(let credential):
            handleSignInWithApple(credential: credential)
        case .failure(let error):
            errorMessage = "Sign in with Apple failed: \(error.localizedDescription)"
        }
    }
}


import SwiftUI
import CloudKit

class ADFriendsViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var friendRequests: [ADFriend] = []
    @Published var friends: [ADFriend] = []
    @Published var challengeRequests: [ADChallenge] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let container = CKContainer.default()
    private lazy var publicDatabase = container.publicCloudDatabase

    init() {
        fetchFriendRequests()
        fetchFriends()
        fetchChallengeRequests()
    }

    func fetchFriendRequests() {
        isLoading = true
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ADFriendRequest", predicate: predicate)

        publicDatabase.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Failed to fetch friend requests: \(error.localizedDescription)"
                    return
                }

                self.friendRequests = records?.compactMap { record in
                    guard let name = record["name"] as? String else { return nil }
                    return ADFriend(id: record.recordID.recordName, name: name)
                } ?? []
            }
        }
    }

    func fetchFriends() {
        isLoading = true
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ADFriend", predicate: predicate)

        publicDatabase.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Failed to fetch friends: \(error.localizedDescription)"
                    return
                }

                self.friends = records?.compactMap { record in
                    guard let name = record["name"] as? String else { return nil }
                    return ADFriend(id: record.recordID.recordName, name: name)
                } ?? []
            }
        }
    }

    func fetchChallengeRequests() {
        isLoading = true
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ADChallengeRequest", predicate: predicate)

        publicDatabase.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Failed to fetch challenge requests: \(error.localizedDescription)"
                    return
                }

                self.challengeRequests = records?.compactMap { record in
                    guard let name = record["name"] as? String else { return nil }
                    return ADChallenge(id: record.recordID.recordName, name: name)
                } ?? []
            }
        }
    }

    func acceptFriendRequest(friend: ADFriend) {
        // Implementation for accepting friend request
        // ...
    }

    func deleteFriend(friend: ADFriend) {
        // Implementation for deleting friend
        // ...
    }

    func acceptChallengeRequest(challenge: ADChallenge) {
        // Implementation for accepting challenge request
        // ...
    }

    func declineChallengeRequest(challenge: ADChallenge) {
        // Implementation for declining challenge request
        // ...
    }
}

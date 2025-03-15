import SwiftUI
import CloudKit

// Friend Model
struct Friend: Identifiable {
    var id: UUID
    var name: String
}

// ViewModel for Friend Requests and Friends
class FriendViewModel: ObservableObject {
    @Published var friendRequests: [Friend] = []
    @Published var friends: [Friend] = []

    // Example functions to simulate data fetching (replace with your actual data logic)
    func fetchFriendRequests() {
        // Replace with your data fetching logic
        friendRequests = [
            Friend(id: UUID(), name: "Alice"),
            Friend(id: UUID(), name: "Bob")
        ]
    }

    func fetchFriends() {
        // Replace with your data fetching logic
        friends = [
            Friend(id: UUID(), name: "Charlie"),
            Friend(id: UUID(), name: "David")
        ]
    }

    func deleteFriendRequest(friend: Friend) {
        friendRequests.removeAll { $0.id == friend.id }
    }

    init() {
        fetchFriendRequests()
        fetchFriends()
    }
}

// ViewModel for MinView
class MinViewModel: ObservableObject {
    @Published var showSideView = false
    @Published var showAlert = false
    @Published var showDeleteConfirmation = false
    @Published var isSignedOut = false

    func signOut() {
        DispatchQueue.main.async {
            self.isSignedOut = true
        }
    }

    func showDeleteConfirmationView() {
        showDeleteConfirmation = true
    }

    func hideDeleteConfirmationView() {
        showDeleteConfirmation = false
    }

    func deleteAccount() {
        // Implement account deletion logic here
        showDeleteConfirmation = false
        // ... Delete account ...
    }
}

// FriendRequestRow View
struct FriendReqestRow: View {
    var friend: Friend
    var onDelete: () -> Void

    var body: some View {
        HStack {
            Text(friend.name)
            Spacer()
            Button(action: onDelete) {
                Text("Delete")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

// Main View for User Settings
struct MinView: View {
    @StateObject private var viewModel = MinViewModel()
    @StateObject private var friendViewModel = FriendViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.1, green: 0, blue: 0.35)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image(systemName: "person.circle")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    Text("Linah")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(.top, 10)
                    VStack(alignment: .leading, spacing: 20) {
                        Text("General")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.top, 30)
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                            Text("Edit name")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        NavigationLink(destination: AddFriendsView()) {
                            HStack {
                                Image(systemName: "person.2")
                                    .foregroundColor(.white)
                                Text("Add Friends")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                        }
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.white)
                            Text("Notifications")
                                .foregroundColor(.white)
                            Spacer()
                            Toggle("", isOn: .constant(true))
                        }
                        .padding(.horizontal)
                        Text("Danger Zone")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.top, 30)
                        Button(action: viewModel.signOut) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.white)
                                Text("Sign Out")
                                    .foregroundColor(.red)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                        Button(action: viewModel.showDeleteConfirmationView) {
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundColor(.white)
                                Text("Delete account")
                                    .foregroundColor(.red)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
                .padding()
                .background(
                    Color(red: 0.1, green: 0.1, blue: 0.35)
                        .edgesIgnoringSafeArea(.all)
                )
            }
            .fullScreenCover(isPresented: $viewModel.isSignedOut, content: {
                SignInView()
            })
        }
        .overlay(
            Group {
                if viewModel.showDeleteConfirmation {
                    deleteConfirmationView
                }
            }
        )
    }

    private var deleteConfirmationView: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Are you sure you want to\nDelete your account?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("This action cannot be undone. Are you sure you\nwant to continue?")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                HStack(spacing: 20) {
                    Button("Cancel") {
                        viewModel.hideDeleteConfirmationView()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Button("Next") {
                        viewModel.deleteAccount()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding(30)
            .background(Color(red: 0.1, green: 0.1, blue: 0.35))
            .cornerRadius(20)
        }
    }
}

// Simple Sign In View
struct SignInView: View {
    var body: some View {
        VStack {
            Text("You have been signed out")
                .font(.title)
                .padding()
            Button("Sign In Again") {
                // Handle re-authentication here
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct MinView_Previews: PreviewProvider {
    static var previews: some View {
        MinView()
    }
}

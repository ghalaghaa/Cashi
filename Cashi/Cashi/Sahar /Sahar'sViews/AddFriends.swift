import SwiftUI
import CloudKit

struct ADFriendsView: View {
    @StateObject private var viewModel = ADFriendsViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.1, green: 0, blue: 0.35)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                    Text("Good evening, Linah")
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                }
                .padding(.horizontal)
                .padding(.top, 8)

                VStack(alignment: .leading) {
                    Text("Add Friends")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 20)
                        .padding(.horizontal)

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                        TextField("Search", text: $viewModel.searchText)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.35)
                            .stroke(Color(red: 0.24, green: 0.43, blue: 0.78), lineWidth: 0.7)
                    )
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                Text("Friend Requests")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 20)
                    .padding(.horizontal)

                ForEach(viewModel.friendRequests) { friend in
                    ADFriendRequestRow(friend: friend, acceptAction: { viewModel.acceptFriendRequest(friend: friend) })
                }

                Text("Your Friends")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 20)
                    .padding(.horizontal)

                ForEach(viewModel.friends) { friend in
                    ADFriendRow(friend: friend, deleteAction: { viewModel.deleteFriend(friend: friend) })
                }

                Text("Challenge Requests")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 20)
                    .padding(.horizontal)

//                ForEach(viewModel.challengeRequests) { challenge in
//                    ADChallengeRequestRow(challenge: challenge, acceptAction: { viewModel.acceptChallengeRequest(challenge: challenge) }, declineAction: { viewModel.declineChallengeRequest(challenge: challenge) })
//                }

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            viewModel.fetchFriendRequests()
            viewModel.fetchFriends()
            viewModel.fetchChallengeRequests()
        }
    }
}

struct ADFriendRequestRow: View {
    let friend: ADFriend
    let acceptAction: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .foregroundColor(.white)
                .font(.system(size: 24))
            Text(friend.name)
                .foregroundColor(.white)
            Spacer()
            Button(action: acceptAction) {
                Text("Accept")
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            Button(action: {}) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding(8)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.35)
                .stroke(Color(red: 0.24, green: 0.43, blue: 0.78), lineWidth: 0.7)
        )
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct ADFriendRow: View {
    let friend: ADFriend
    let deleteAction: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
            
        }}}

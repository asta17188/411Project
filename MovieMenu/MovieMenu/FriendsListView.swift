import SwiftUI

struct FriendsListView: View {
    @State private var friends: [Friend] = []
    @EnvironmentObject var auth: AuthViewModel
    private let firestore = FirestoreService()

    var body: some View {
        NavigationView {
            List(friends) { friend in
                NavigationLink(destination: FriendDetailView(friend: friend)) {
                    Text(friend.email)
                }
            }
            .navigationTitle("Friends")
            .onAppear(perform: loadFriends)
        }
    }

    private func loadFriends() {
        guard let userID = auth.user?.uid else { return }
        firestore.fetchFriends { self.friends = $0 }
    }
}

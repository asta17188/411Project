import SwiftUI
import FirebaseAuth

struct UserProfileView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var watchedMovies: [WatchedItem] = []
    @State private var watchedAnime: [WatchedItem] = []
    @State private var friendEmail: String = ""
    @State private var addFriendMessage: String?
    @State private var sentRequestsEmails: [String] = []
    @State private var receivedRequestsEmails: [(email: String, requestID: String)]  = []

    private let firestore = FirestoreService()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.black, .gray]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                if let user = auth.user {
                    Text("Hello, \(user.email ?? "Guest") 👋")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top, 16)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Group {
                                Text("Watched Movies")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                ForEach(watchedMovies) { movie in
                                    WatchedItemView(item: movie, onDelete: {
                                        deleteMovie(movie)
                                    }, showDeleteButton: true)
                                }
                                Divider().background(Color.white)

                                Text("Watched Anime")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                ForEach(watchedAnime) { anime in
                                    WatchedItemView(item: anime, onDelete: {
                                        deleteAnime(anime)
                                    }, showDeleteButton: true)
                                }
                            }

                            Divider().background(Color.white)

                            Group {
                                Text("Add Friend by Email")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                HStack {
                                    TextField("Enter friend's email", text: $friendEmail)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .autocapitalization(.none)

                                    Button(action: {
                                        addFriend()
                                    }) {
                                        Text("Add")
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }

                                if let message = addFriendMessage {
                                    Text(message)
                                        .foregroundColor(.yellow)
                                        .font(.subheadline)
                                }
                            }

                            // Sent Friend Requests
                            Divider().background(Color.white)

                            Group {
                                Text("Sent Friend Requests")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                if sentRequestsEmails.isEmpty {
                                    Text("No sent friend requests.")
                                        .foregroundColor(.gray)
                                } else {
                                    ForEach(sentRequestsEmails, id: \.self) { email in
                                        Text(email)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 4)
                                    }
                                }
                            }

                            // Received Friend Requests
                            Divider().background(Color.white)

                            Group {
                                Text("Received Friend Requests")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                if receivedRequestsEmails.isEmpty {
                                    Text("No received friend requests.")
                                        .foregroundColor(.gray)
                                } else {
                                    ForEach(receivedRequestsEmails, id: \.requestID) { request in
                                        HStack {
                                            Text(request.email)
                                                .foregroundColor(.white)
                                            Spacer()
                                            Button("Accept") {
                                                acceptFriendRequest(requestID: request.requestID, fromEmail: request.email)
                                            }
                                            .padding(6)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }

                    Button("Sign Out") {
                        auth.signOut()
                    }
                    .foregroundColor(.red)
                    .padding(.bottom)
                } else {
                    Text("Not signed in")
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            if let user = auth.user {
                fetchData(userID: user.uid)
                fetchSentRequests(for: user.uid)
                fetchReceivedRequests(for: user.uid)
            }
        }
    }
    
    private func acceptFriendRequest(requestID: String, fromEmail: String) {
        guard let currentUID = auth.user?.uid else { return }

        firestore.db.collection("users")
            .whereField("email", isEqualTo: fromEmail)
            .getDocuments { snapshot, error in
                guard let senderDoc = snapshot?.documents.first else {
                    print("Sender not found")
                    return
                }

                let senderUID = senderDoc.documentID

                firestore.acceptFriendRequest(from: senderUID, to: currentUID) { error in
                    if let error = error {
                        print("Failed to accept request: \(error)")
                    } else {
                        fetchReceivedRequests(for: currentUID)
                        fetchSentRequests(for: currentUID)
                        fetchData(userID: currentUID)
                    }
                }
            }
    }

    
    private func fetchSentRequests(for userID: String) {
        firestore.fetchSentRequests(for: userID) { ids in
            let group = DispatchGroup()
            var emails: [String] = []

            for id in ids {
                group.enter()
                firestore.db.collection("users").document(id).getDocument { doc, _ in
                    if let email = doc?.data()?["email"] as? String {
                        emails.append(email)
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                sentRequestsEmails = emails
            }
        }
    }

    private func fetchReceivedRequests(for userID: String) {
        firestore.db.collection("friend_requests")
            .whereField("to", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching received friend requests: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let group = DispatchGroup()
                var newRequests: [(email: String, requestID: String)] = []

                for doc in documents {
                    let requestID = doc.documentID
                    if let senderUID = doc["from"] as? String {
                        group.enter()
                        firestore.db.collection("users").document(senderUID).getDocument { userDoc, _ in
                            if let email = userDoc?.data()?["email"] as? String {
                                newRequests.append((email: email, requestID: requestID))
                            }
                            group.leave()
                        }
                    }
                }

                group.notify(queue: .main) {
                    receivedRequestsEmails = newRequests
                }
            }
    }
    private func fetchData(userID: String) {
        firestore.fetchWatchedMovies(for: userID) { items in
            watchedMovies = items
        }
        firestore.fetchWatchedAnime(for: userID) { items in
            watchedAnime = items
        }
    }

    private func deleteMovie(_ movie: WatchedItem) {
        firestore.deleteWatchedMovie(id: movie.id) { error in
            if let error = error {
                print("Failed to delete movie: \(error)")
            } else {
                watchedMovies.removeAll { $0.id == movie.id }
            }
        }
    }

    private func deleteAnime(_ anime: WatchedItem) {
        firestore.deleteWatchedAnime(id: anime.id) { error in
            if let error = error {
                print("Failed to delete anime: \(error)")
            } else {
                watchedAnime.removeAll { $0.id == anime.id }
            }
        }
    }

    private func addFriend() {
        guard !friendEmail.isEmpty else {
            addFriendMessage = "Please enter an email address."
            return
        }

        guard let currentUID = auth.user?.uid else {
            addFriendMessage = "User not signed in."
            return
        }

        firestore.addFriend(byEmail: friendEmail) { error in
            if let error = error {
                addFriendMessage = "Error: \(error.localizedDescription)"
            } else {
                addFriendMessage = "Friend request sent to \(friendEmail)"
                friendEmail = ""

                fetchSentRequests(for: currentUID)
            }
        }
    }
}

struct WatchedItemView: View {
    let item: WatchedItem
    let onDelete: () -> Void
    let showDeleteButton: Bool

    var body: some View {
        HStack(alignment: .top) {
            if let url = URL(string: item.posterURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 80, height: 110)
                .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(item.description)
                    .font(.subheadline)
                    .lineLimit(3)
                    .foregroundColor(.white)

                if !item.notes.isEmpty {
                    Text("📝 Notes: \(item.notes)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                if item.rating > 0 {
                    Text("⭐️ Rating: \(item.rating)/10")
                        .font(.footnote)
                        .foregroundColor(.orange)
                }

                // Show delete button conditionally
                if showDeleteButton {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Text("🗑 Delete")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.6))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

#Preview {
    UserProfileView()
}

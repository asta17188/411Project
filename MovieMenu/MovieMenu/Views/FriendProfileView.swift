import SwiftUI

struct FriendProfileView: View {
    let friendID: String
    let email: String

    @State private var watchedMovies: [WatchedItem] = []
    @State private var watchedAnime: [WatchedItem] = []
    private let firestore = FirestoreService()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("\(email)'s Watched Movies")
                    .font(.title2)
                    .bold()

                if watchedMovies.isEmpty {
                    Text("No movies watched.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(watchedMovies) { movie in
                        WatchedItemView(item: movie, onDelete: {
                        }, showDeleteButton: false)
                    }
                }

                Divider()

                Text("\(email)'s Watched Anime")
                    .font(.title2)
                    .bold()

                if watchedAnime.isEmpty {
                    Text("No anime watched.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(watchedAnime) { anime in
                        WatchedItemView(item: anime, onDelete: {
                        }, showDeleteButton: false)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(email)
        .onAppear {
            firestore.fetchWatchedMovies(for: friendID) { self.watchedMovies = $0 }
            firestore.fetchWatchedAnime(for: friendID) { self.watchedAnime = $0 }
        }
    }
}

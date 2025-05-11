//
//  FriendDetailView.swift
//  MovieMenu
//
//  Created by csuftitan on 5/10/25.
//


import SwiftUI

struct FriendDetailView: View {
    let friend: Friend
    @State private var watchedMovies: [WatchedItem] = []
    @State private var watchedAnime: [WatchedItem] = []

    private let firestore = FirestoreService()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("\(friend.email)'s Watched Movies")
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

                Text("\(friend.email)'s Watched Anime")
                    .font(.title2)
                    .bold()

                if watchedAnime.isEmpty {
                    Text("No anime watched.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(watchedAnime) { anime in
                        WatchedItemView(item: anime, onDelete: {
                        }, showDeleteButton: false)
                    }                }
            }
            .padding()
        }
        .navigationTitle(friend.email)
        .onAppear {
            firestore.fetchWatchedMovies(for: friend.id) { movies in
                watchedMovies = movies
            }
            firestore.fetchWatchedAnime(for: friend.id) { anime in
                watchedAnime = anime
            }
        }
    }
}

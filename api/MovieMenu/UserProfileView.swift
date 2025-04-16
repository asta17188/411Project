//
//  UserProfileView.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/15/25.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var watchedMovies: [WatchedItem] = []
    @State private var watchedAnime: [WatchedItem] = []
    private let firestore = FirestoreService()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("👋 Welcome, \(auth.user?.email ?? "User")!")
                        .font(.title2)
                        .bold()
                        .padding(.top)

                    Button("Logout") {
                        auth.signOut()
                    }
                    .foregroundColor(.red)

                    Group {
                        Text("🎬 Watched Movies")
                            .font(.headline)

                        ForEach(watchedMovies) { movie in
                            WatchedItemView(item: movie)
                        }
                    }

                    Divider()

                    Group {
                        Text("📺 Watched Anime")
                            .font(.headline)

                        ForEach(watchedAnime) { anime in
                            WatchedItemView(item: anime)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .onAppear {
                firestore.fetchWatchedMovies { watchedMovies = $0 }
                firestore.fetchWatchedAnime { watchedAnime = $0 }
            }
        }
    }
}

struct WatchedItemView: View {
    let item: WatchedItem

    var body: some View {
        HStack(alignment: .top) {
            if let url = URL(string: item.posterURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 80, height: 110)
                .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)

                Text(item.description)
                    .font(.subheadline)
                    .lineLimit(3)
                    .foregroundColor(.secondary)

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
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    UserProfileView()
}

//
//  AnimeDetailView.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/15/25.
//

import SwiftUI

struct AnimeDetailView: View {
    let anime: Anime
    @State private var message: String?
    @State private var notes = ""
    @State private var rating = 5
    private let firestore = FirestoreService()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = anime.images?.jpg.image_url,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                }

                Text(anime.title)
                    .font(.title)
                    .bold()

                Text(anime.synopsis ?? "No synopsis available.")
                    .font(.body)
                
                Text("Your Notes")
                    .font(.headline)
                
                TextEditor(text: $notes)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                
                Text("Rating: \(rating)/10")
                Slider(value: Binding(
                    get: { Double(rating) },
                    set: { rating = Int($0) }
                ), in: 0...10, step: 1)

                Button("Add to Watched") {
                    firestore.addAnimeToWatched(anime, notes: notes, rating: rating) { error in
                        if let error = error {
                            message = "Failed: \(error.localizedDescription)"
                        } else {
                            message = "🎉 Anime added to your watched list!"
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                if let message = message {
                    Text(message)
                        .foregroundColor(.green)
                        .padding(.top, 8)
                }
            }
            .padding()
        }
        .navigationTitle("Anime Details")
    }
}

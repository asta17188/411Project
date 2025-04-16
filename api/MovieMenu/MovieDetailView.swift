//
//  MovieDetailView.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/15/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @State private var message: String?
    @State private var notes = ""
    @State private var rating = 5
    private let firestore = FirestoreService()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)") {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                }

                Text(movie.title)
                    .font(.title)
                    .bold()

                Text(movie.overview)
                    .font(.body)
                
                TextEditor(text: $notes)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                
                Text("Rating: \(rating)/10")
                Slider(value: Binding(
                    get: { Double(rating) },
                    set: { rating = Int($0) }
                ), in: 0...10, step: 1)

                Button("Add to Watched") {
                    firestore.addMovieToWatched(movie, notes: notes, rating: rating) { error in
                        if let error = error {
                            message = "Failed: \(error.localizedDescription)"
                        } else {
                            message = "🎉 Movie added to your watched list!"
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
        .navigationTitle("Movie Details")
    }
}

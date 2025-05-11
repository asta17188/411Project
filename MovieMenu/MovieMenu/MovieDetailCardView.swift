//
//  MovieDetailCardView.swift
//  MovieMenu
//
//  Created by csuftitan on 5/8/25.
//


import SwiftUI

struct MovieDetailCardView: View {
    let movie: Movie
    @State private var message: String?
    @State private var notes = ""
    @State private var rating = 5
    private let firestore = FirestoreService()
    
    var body: some View {
        ZStack(alignment: .top) {
            AppBackground()
            VStack(alignment: .leading) {
                if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 350)
                            .padding(.top, 70)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(movie.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text(movie.overview)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                TextEditor(text: $notes)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                
                Text("⭐️ Rating: \(rating)/10")
                    .foregroundColor(.white)
                
                Slider(value: Binding(get: {
                    Double(rating)
                }, set: {
                    rating = Int($0)
                }), in: 0...10, step: 1)
                
                Button("Add to Watched") {
                    firestore.addMovieToWatched(movie, notes: notes, rating: rating) { error in
                        message = error == nil ? "🎉 Added!" : error?.localizedDescription
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 80)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 80)
                    
                    if let message = message {
                        Text(message).foregroundColor(.green)
                    }
                }
                .padding()
            }
        }
    }
}

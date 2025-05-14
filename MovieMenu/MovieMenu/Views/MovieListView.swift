//
//  MovieListView.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/14/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        Text(movie.overview)
                            .font(.subheadline)
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Popular Movies")
        }
        .onAppear {
            print("Search view appeared")
            viewModel.loadMovies()
        }
    }
}

#Preview {
    MovieListView()
}

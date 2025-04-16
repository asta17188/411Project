//
//  MovieViewModel.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/14/25.
//

import Foundation

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private let service = MovieService()

    func loadMovies() {
        service.fetchPopularMovies { [weak self] movies in
            DispatchQueue.main.async {
                self?.movies = movies
            }
        }
    }
}

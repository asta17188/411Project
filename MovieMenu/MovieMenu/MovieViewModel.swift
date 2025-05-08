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

    func search(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            loadMovies()
            return
        }

        service.searchMovies(query: query) { [weak self] movies in
            DispatchQueue.main.async {
                self?.movies = movies
            }
        }
    }
}

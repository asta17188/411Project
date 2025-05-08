import Foundation

class MovieService {
    private let apiKey: String = {
        guard let key = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
            fatalError("TMDB_API_KEY not found in Info.plist")
        }
        return key
    }()
    
    private let baseURL = "https://api.themoviedb.org/3"

    func fetchPopularMovies(completion: @escaping ([Movie]) -> Void) {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        fetchMovies(from: urlString, completion: completion)
    }

    func searchMovies(query: String, completion: @escaping ([Movie]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion([])
            return
        }
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)&language=en-US&page=1"
        fetchMovies(from: urlString, completion: completion)
    }

    private func fetchMovies(from urlString: String, completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion([])
                return
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                    completion(response.results)
                } catch {
                    print("❌ Decoding error: \(error)")
                    completion([])
                }
            } else {
                print("❌ No data received")
                completion([])
            }
        }.resume()
    }
}

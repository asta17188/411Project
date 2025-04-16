//
//  MovieService.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/14/25.
//

import Foundation

private var apiKey: String {
    if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path),
       let key = dict["TMDB_API_KEY"] as? String {
        return key
    } else {
        print("⚠️ Could not load API key from Secrets.plist")
        return ""
    }
}

class MovieService {
    private let baseURL = "https://api.themoviedb.org/3"

    func fetchPopularMovies(completion: @escaping ([Movie]) -> Void) {
        guard !apiKey.isEmpty else {
            completion([])
            return
        }

        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "unknown")")
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(decoded.results)
            } catch {
                print("Decoding error: \(error)")
                completion([])
            }
        }.resume()
    }

}

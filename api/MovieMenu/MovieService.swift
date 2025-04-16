//
//  MovieMenuService.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/14/25.
//

//
//  MovieService.swift
//
//
//  Created by Jeremiah Herring on 4/14/25.
//

import Foundation

struct Movie: Decodable, Identifiable {
    let id = UUID()
    let title: String
    let overview: String
    let poster_path: String

    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case poster_path
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}

class MovieService {
    private let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    private let baseURL = "https://api.themoviedb.org/3"

    func fetchPopularMovies(completion: @escaping ([Movie]) -> Void) {
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
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Decoding error: \(error)")
                completion([])
            }
        }.resume()
    }
}


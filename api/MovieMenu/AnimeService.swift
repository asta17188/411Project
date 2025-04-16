//
//  AnimeService.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/14/25.
//

import Foundation

class AnimeService {
    private let baseURL = "https://api.jikan.moe/v4/top/anime"

    func fetchTopAnime(completion: @escaping ([Anime]) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Anime API error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
                completion(decoded.data)
            } catch {
                print("Decoding anime error: \(error)")
                completion([])
            }
        }.resume()
    }
}

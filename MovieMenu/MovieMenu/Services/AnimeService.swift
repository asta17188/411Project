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
    func searchAnime(query: String, completion: @escaping ([Anime]) -> Void) {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.jikan.moe/v4/anime?q=\(encoded)&limit=25"

        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                print("Anime search error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
                completion(decoded.data)
            } catch {
                print("❌ Decoding error: \(error.localizedDescription)")
                completion([])
            }


        }.resume()
    }
}

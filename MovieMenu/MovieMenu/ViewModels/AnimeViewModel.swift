//
//  AnimeViewModel.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/14/25.
//

import Foundation

class AnimeViewModel: ObservableObject {
    @Published var animeList: [Anime] = []
    private let service = AnimeService()

    func loadAnime() {
        service.fetchTopAnime { [weak self] anime in
            DispatchQueue.main.async {
                self?.animeList = anime
            }
        }
    }
    func search(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            loadAnime()
            return
        }

        service.searchAnime(query: query) { [weak self] results in
            DispatchQueue.main.async {
                self?.animeList = results
            }
        }
    }

}

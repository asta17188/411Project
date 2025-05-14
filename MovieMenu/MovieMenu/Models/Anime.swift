//
//  Anime.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/14/25.
//

import Foundation

struct AnimeResponse: Decodable {
    let data: [Anime]
}

struct Anime: Decodable, Identifiable {
    let mal_id: Int
    let title: String
    let synopsis: String?
    let images: Images?

    var id: Int { mal_id }

    struct Images: Decodable {
        let jpg: ImageURLs
        struct ImageURLs: Decodable {
            let image_url: String
        }
    }
}

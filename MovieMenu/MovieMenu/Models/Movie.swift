//
//  Movie.swift
//  MovieMenu
//
//  Created by csuftitan on 5/7/25.
//


//
//  Movie.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/15/25.
//

import Foundation

struct Movie: Identifiable, Codable, Hashable, Equatable {
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

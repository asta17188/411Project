//
//  WatchedItem.swift
//  MovieMenu
//
//  Created by Jeremiah Herring on 4/15/25.
//

import Foundation

struct WatchedItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let posterURL: String
    let notes: String
    let rating: Int
}



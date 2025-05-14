//
//  Item.swift
//  MovieMenu
//
//  Created by Elena Marquez on 4/14/25.
//


import Foundation
import SwiftData

@Model
class Item {
    var title: String
    var rating: Int
    var review: String
    var date: Date

    init(title: String, rating: Int, review: String, date: Date = Date()) {
        self.title = title
        self.rating = rating
        self.review = review
        self.date = date
    }
}
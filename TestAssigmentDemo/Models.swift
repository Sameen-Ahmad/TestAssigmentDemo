//
//  Models.swift
//  TestAssigmentDemo
//
//  Created by ginger on 05/12/24.
//

import Foundation


struct MovieSearchResults: Codable {
    let page: Int
    let results: [Movie]
    let totalResults: Int
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String?
    let overview: String
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
        case rating = "vote_average"
    }
}



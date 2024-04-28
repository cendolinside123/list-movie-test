//
//  MovieItem.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation

// MARK: - MovieItemResponse
struct MovieItemResponse: Codable {
    let page: Int
    let results: [MovieOnlineModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

//
//  BelongsToCollectionModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation

// MARK: - BelongsToCollectionModel
struct BelongsToCollectionModel: Codable {
    let id: Int
    let name, posterPath: String
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

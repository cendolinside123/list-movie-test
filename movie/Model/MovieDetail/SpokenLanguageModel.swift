//
//  SpokenLanguageModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation

// MARK: - SpokenLanguageModel
struct SpokenLanguageModel: Codable {
    let englishName, iso639_1, name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

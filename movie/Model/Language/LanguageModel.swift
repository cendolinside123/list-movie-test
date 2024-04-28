//
//  LanguageModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation


// MARK: - LanguageModel
struct LanguageModel: Codable {
    let iso639_1, englishName, name: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case englishName = "english_name"
        case name
    }
}

typealias LanguageItem = [LanguageModel]

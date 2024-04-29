//
//  ProductionCountryModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation


// MARK: - ProductionCountryModel
struct ProductionCountryEntity: Codable {
    let iso3166_1, name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

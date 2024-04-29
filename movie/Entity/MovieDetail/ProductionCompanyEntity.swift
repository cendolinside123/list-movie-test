//
//  ProductionCompanyModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation


// MARK: - ProductionCompanyModel
struct ProductionCompanyEntity: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

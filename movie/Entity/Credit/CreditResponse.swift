//
//  CreditResponse.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation

// MARK: - CreditResponse
struct CreditResponse: Codable {
    let id: Int
    let cast, crew: [CastEntity]
}

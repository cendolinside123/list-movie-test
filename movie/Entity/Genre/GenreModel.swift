//
//  GenreModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation


// MARK: - GenreModel
struct GenreEntity: Codable, Hashable {
    let id: Int
    let name: String
    
    static func == (lhs: GenreEntity, rhs: GenreEntity) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        
    }
}

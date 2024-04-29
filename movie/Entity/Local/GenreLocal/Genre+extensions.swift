//
//  Genre+extensions.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData

extension Genre {
    func toNormalEntity() -> GenreEntity? {
        if let name {
            return GenreEntity(id: Int(self.id), name: name)
        }
        
        return nil
    }
}

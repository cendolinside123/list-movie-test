//
//  Genre+extensions.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData

extension Genre {
    func toNormalModel() -> GenreModel? {
        if let name {
            return GenreModel(id: Int(self.id), name: name)
        }
        
        return nil
    }
}

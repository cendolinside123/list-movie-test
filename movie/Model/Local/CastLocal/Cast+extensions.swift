//
//  Cast+extensions.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData

extension Cast {
    func toNormalModel() -> CastModel? {
        
        if let knownForDepartment,
            let name,
            let originalName ,
            let creditID {
            
            
            return CastModel(adult: self.adult, 
                             gender: Int(self.gender),
                             id: Int(self.id),
                             knownForDepartment: knownForDepartment,
                             name: name,
                             originalName: originalName, 
                             popularity: self.popularity,
                             profilePath: self.profilePath,
                             castID: Int(castID),
                             character: self.character,
                             creditID: creditID,
                             order: Int(self.order),
                             department: self.department,
                             job: self.job
            )
        }
        
        return nil
    }
}

//
//  Movie+extensions.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData

extension Movie {
    func toNormalModel() -> MovieModel? {
        
        if let genreIDS, let originalLanguage, let originalTitle, let overview, let posterPath, let releaseDate, let title {
            return MovieModel(adult: self.adult, backdropPath: self.backdropPath, genreIDS: genreIDS, id: Int(id), originalLanguage: originalLanguage, originalTitle: originalTitle, overview: overview, popularity: self.popularity, posterPath: posterPath, releaseDate: releaseDate, title: title, video: self.video, voteAverage: self.voteAverage, voteCount: Int(self.voteCount))
        }
        
        return nil
    }
}

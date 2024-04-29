//
//  MovieDetail+extensions.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData

extension MovieDetail {
    func toNormalEntity() -> MovieDetailEntity? {
        
        if let backdropPath, 
            let genres,
            let homepage,
            let imdbID,
            let originalLanguage,
            let originalTitle, 
            let overview,
            let posterPath, let releaseDate, let status, let tagline, let title {
            
            
            var getBelongsToCollection: BelongsToCollectionEntity?
            if let belongsToCollection {
                getBelongsToCollection = try? JSONDecoder().decode(BelongsToCollectionEntity.self, from: belongsToCollection)
            }
            
            guard let originCountry, 
                    let getOriginCountry = try? JSONDecoder().decode([String].self, from: originCountry) else {
                return nil
            }
            
            guard let productionCompanies, let getProductionCompany = try? JSONDecoder().decode([ProductionCompanyEntity].self, from: productionCompanies) else {
                return nil
            }
            
            guard let productionCountries, let getProdutionCountries = try? JSONDecoder().decode([ProductionCountryEntity].self, from: productionCountries) else {
                return nil
            }
            
            guard let spokenLanguages, let getSpokenLaguage = try?  JSONDecoder().decode([SpokenLanguageEntity].self, from: spokenLanguages) else {
                return nil
            }
            
            return MovieDetailEntity(adult: self.adult, backdropPath: backdropPath, belongsToCollection: getBelongsToCollection, budget: Int(self.budget), genres: genres, homepage: homepage, id: Int(self.id), imdbID: imdbID, originCountry: getOriginCountry, originalLanguage: originalLanguage, originalTitle: originalTitle, overview: overview, popularity: self.popularity, posterPath: posterPath, productionCompanies: getProductionCompany, productionCountries: getProdutionCountries, releaseDate: releaseDate, revenue: Int(self.revenue), runtime: Int(self.runtime), spokenLanguages: getSpokenLaguage, status: status, tagline: tagline, title: title, video: self.video, voteAverage: self.voteAverage, voteCount: Int(self.voteCount), overViewSize: nil)
        }
        
        return nil
    }
}

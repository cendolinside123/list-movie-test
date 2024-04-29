//
//  MovieDetail+extensions.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData

extension MovieDetail {
    func toNormalModel() -> MovieDetailModel? {
        
        if let backdropPath, 
            let genres,
            let homepage,
            let imdbID,
            let originalLanguage,
            let originalTitle, 
            let overview,
            let posterPath, let releaseDate, let status, let tagline, let title {
            
            
            var getBelongsToCollection: BelongsToCollectionModel?
            if let belongsToCollection {
                getBelongsToCollection = try? JSONDecoder().decode(BelongsToCollectionModel.self, from: belongsToCollection)
            }
            
            guard let originCountry, 
                    let getOriginCountry = try? JSONDecoder().decode([String].self, from: originCountry) else {
                return nil
            }
            
            guard let productionCompanies, let getProductionCompany = try? JSONDecoder().decode([ProductionCompanyModel].self, from: productionCompanies) else {
                return nil
            }
            
            guard let productionCountries, let getProdutionCountries = try? JSONDecoder().decode([ProductionCountryModel].self, from: productionCountries) else {
                return nil
            }
            
            guard let spokenLanguages, let getSpokenLaguage = try?  JSONDecoder().decode([SpokenLanguageModel].self, from: spokenLanguages) else {
                return nil
            }
            
            return MovieDetailModel(adult: self.adult, backdropPath: backdropPath, belongsToCollection: getBelongsToCollection, budget: Int(self.budget), genres: genres, homepage: homepage, id: Int(self.id), imdbID: imdbID, originCountry: getOriginCountry, originalLanguage: originalLanguage, originalTitle: originalTitle, overview: overview, popularity: self.popularity, posterPath: posterPath, productionCompanies: getProductionCompany, productionCountries: getProdutionCountries, releaseDate: releaseDate, revenue: Int(self.revenue), runtime: Int(self.runtime), spokenLanguages: getSpokenLaguage, status: status, tagline: tagline, title: title, video: self.video, voteAverage: self.voteAverage, voteCount: Int(self.voteCount))
        }
        
        return nil
    }
}

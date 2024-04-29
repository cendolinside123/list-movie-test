//
//  MovieDetailModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation

struct MovieDetailEntity {
    let adult: Bool
    let backdropPath: String
    let belongsToCollection: BelongsToCollectionEntity?
    let budget: Int
    let genres: String
    let homepage: String
    let id: Int
    let imdbID: String
    let originCountry: [String]
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String
    let productionCompanies: [ProductionCompanyEntity]
    let productionCountries: [ProductionCountryEntity]
    let releaseDate: String
    let revenue, runtime: Int
    let spokenLanguages: [SpokenLanguageEntity]
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    var overViewSize: CGSize?
}

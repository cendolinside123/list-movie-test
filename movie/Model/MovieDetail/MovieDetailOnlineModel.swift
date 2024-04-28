//
//  MovieDetailOnlineModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation


// MARK: - MovieDetailOnlineModel
struct MovieDetailOnlineModel: Codable {
    let adult: Bool
    let backdropPath: String
    let belongsToCollection: BelongsToCollectionModel
    let budget: Int
    let genres: [GenreModel]
    let homepage: String
    let id: Int
    let imdbID: String
    let originCountry: [String]
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String
    let productionCompanies: [ProductionCompanyModel]
    let productionCountries: [ProductionCountryModel]
    let releaseDate: String
    let revenue, runtime: Int
    let spokenLanguages: [SpokenLanguageModel]
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

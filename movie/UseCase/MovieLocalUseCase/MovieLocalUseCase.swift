//
//  MovieLocalUseCase.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData
import RxSwift

protocol MovieLocalUseCase {
    func inputMovie(value: MovieModel) -> Completable
    func getMovie(movieID: Int) -> Single<Movie?>
    func getAllMovie() -> Single<[Movie]>
    func inputMovieDetail(movie: Movie, valueDetail: MovieDetailModel, cast: [CastModel]) -> Completable
    func getMovieDetail(movieID: Int) -> Single<MovieDetail?>
}

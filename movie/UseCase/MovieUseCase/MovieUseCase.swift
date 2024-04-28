//
//  MovieUseCase.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import RxSwift

protocol MovieUseCase {
    func searchMovie(keyWord: String, isAdultAllow: Bool, page: Int) -> Single<MovieItemResponse>
    func fetchMovie(isAdultAllow: Bool, page: Int) -> Single<MovieItemResponse>
    func fetchMovieDetail(movieID: Int) -> Single<MovieDetailOnlineModel>
    
}

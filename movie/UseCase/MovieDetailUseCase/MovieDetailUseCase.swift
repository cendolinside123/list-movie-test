//
//  MovieDetailUseCase.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import RxSwift

protocol MovieDetailUseCase {
    func fetchMovieDetail(movieID: Int) -> Single<MovieDetailOnlineModel>
}

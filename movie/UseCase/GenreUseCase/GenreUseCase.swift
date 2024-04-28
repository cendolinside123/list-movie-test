//
//  GenreUseCase.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import RxSwift

protocol GenreUseCase {
    func fetchListGenreMovie(language: String) -> Single<GenreResponse>
    func fetchListGenreTV(language: String) -> Single<GenreResponse>
}

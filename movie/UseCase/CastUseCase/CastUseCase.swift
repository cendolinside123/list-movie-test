//
//  CastUseCase.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import RxSwift

protocol CastUseCase {
    func fetchMovieCredits(movieID: Int) -> Single<CreditResponse>
}

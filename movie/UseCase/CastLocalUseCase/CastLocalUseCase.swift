//
//  CastLocalUseCase.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData
import RxSwift

protocol CastLocalUseCase {
    func doInputCast(movie: Movie, value: [CastModel]) -> Completable
}

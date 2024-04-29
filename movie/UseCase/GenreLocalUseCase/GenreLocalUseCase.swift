//
//  GenreLocalUseCase.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData
import RxSwift

protocol GenreLocalUseCase {
    func addGenre(value: GenreEntity) -> Completable
    func fetchAllGenre() -> Single<[Genre]>
}

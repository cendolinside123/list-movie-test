//
//  MoviedetailInteractor.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation


protocol MoviedetailInteractorAct: AnyObject {
    func onSuccess(value: (MovieDetailEntity, [CastEntity]))
    func onError(error: Error)
}

protocol MoviedetailInteractor {
    var delegate: MoviedetailInteractorAct? { get set }
    
    func loadMovieDetail(movieID: Int)
}

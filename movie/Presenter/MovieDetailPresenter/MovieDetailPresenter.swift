//
//  MovieDetailViewModel.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation


protocol MovieDetailDelegate: AnyObject {
    func onSuccess(value: (MovieDetailEntity, [CastEntity]))
    func onError(error: Error)
    func onLoading()
    func onEndLoading()
}

protocol MovieDetailPresenter {
    var delegate: MovieDetailDelegate? { get set }
    
    func loadMovieDetail(movieID: Int)
}

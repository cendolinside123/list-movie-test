//
//  MovieDetailViewModel.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation


protocol MovieDetailDelegate: AnyObject {
    func onSuccess()
    func onError(error: Error)
    func onLoading()
    func onEndLoading()
}

protocol MovieDetailViewModel {
    associatedtype DetailMovie
    
    
    var movieInformation: DetailMovie? { get set }
    var delegate: MovieDetailDelegate? { get set }
    
    func loadMovieDetail(movieID: Int)
}


class DummyMovieDetailVM<T>: MovieDetailViewModel {
    typealias DetailMovie = T
    
    
    var movieInformation: T?
    
    var delegate: MovieDetailDelegate?
    
    func loadMovieDetail(movieID: Int) {
        
    }
}

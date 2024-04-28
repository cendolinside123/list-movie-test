//
//  MovieListViewModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation


protocol MovieListDelegate: AnyObject {
    func onSuccess()
    func onError(error: Error)
    func onLoading()
    func onEndLoading()
}

protocol MovieListViewModel {
    associatedtype MovieData
    
    var listMovie: MovieData? { get set }
    var delegate: MovieListDelegate? { get set }
    
    func firstInitials()
    func fetchMovie(isReFetch: Bool)
    func fetchMovie(keyWord: String, isRefetch: Bool)
}

class DummyMovielistVM<T>: MovieListViewModel {
    typealias MovieData = T
    var listMovie: T?
    
    var delegate: MovieListDelegate?
    
    func firstInitials() {
        
    }
    
    func fetchMovie(isReFetch: Bool) {
        
    }
    
    func fetchMovie(keyWord: String, isRefetch: Bool) {
        
    }
}

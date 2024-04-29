//
//  MovieListViewModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation


protocol MovieListDelegate: AnyObject {
    func onSuccess(newData: [MovieModel])
    func onError(error: Error)
    func clearList()
    func onLoading()
    func onEndLoading()
}

protocol MovieListPresenter {
    associatedtype MovieData
    
    var delegate: MovieListDelegate? { get set }
    
    func firstInitials()
    func fetchMovie(isReFetch: Bool, oldData: MovieData)
    func fetchMovie(keyWord: String, isRefetch: Bool, oldData: MovieData)
}

class DummyMovielistPresenter<T>: MovieListPresenter {
    typealias MovieData = T
    
    weak var delegate: MovieListDelegate?
    
    func firstInitials() {
        
    }
    
    func fetchMovie(isReFetch: Bool, oldData: T) {
        
    }
    
    func fetchMovie(keyWord: String, isRefetch: Bool, oldData: T) {
        
    }
}

protocol MovieListViewModel {
    associatedtype MovieData
    
    var listMovie: MovieData? { get set }
    var delegate: MovieListDelegate? { get set }
    
    func firstInitials()
    func fetchMovie(isReFetch: Bool)
    func fetchMovie(keyWord: String, isRefetch: Bool)
}

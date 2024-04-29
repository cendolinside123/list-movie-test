//
//  MovieListInteractor.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation

protocol MovieListIteratoract: AnyObject {
    func onSuccess(newData: [MovieEntity])
    func onError(error: Error)
}


protocol MovieListInteractor {
    var delegate: MovieListIteratoract? { get set }
    var isOnLoad: Bool { get set }
    
    func firstInitials()
    func fetchMovie(isReFetch: Bool)
    func fetchMovie(keyWord: String, isRefetch: Bool)
}

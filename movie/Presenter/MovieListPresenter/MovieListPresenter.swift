//
//  MovieListViewModel.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation


protocol MovieListDelegate: AnyObject {
    func onSuccess(newData: [MovieEntity])
    func onError(error: Error)
    func clearList()
    func onLoading()
    func onEndLoading()
}

protocol MovieListPresenter {
    
    var delegate: MovieListDelegate? { get set }
    
    func firstInitials()
    func fetchMovie(isReFetch: Bool)
    func fetchMovie(keyWord: String, isRefetch: Bool)
}

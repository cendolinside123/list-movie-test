//
//  MovieDetailViewModelImpl.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import RxSwift

class MovieDetailPresenterImpl {
    
    private var disposableBag = DisposeBag()
    weak var delegate: MovieDetailDelegate?
    private var interactor: MoviedetailInteractor = MoviedetailInteractorImpl()
    
    init() {
        interactor.delegate = self
    }
    
    
}

extension MovieDetailPresenterImpl: MovieDetailPresenter {
    func loadMovieDetail(movieID: Int) {
        
        delegate?.onLoading()
        interactor.loadMovieDetail(movieID: movieID)
    }
}

extension MovieDetailPresenterImpl: MoviedetailInteractorAct {
    func onSuccess(value: (MovieDetailEntity, [CastEntity])) {
        delegate?.onEndLoading()
        delegate?.onSuccess(value: value)
    }
    
    func onError(error: Error) {
        delegate?.onEndLoading()
        delegate?.onError(error: error)
    }
    
    
}

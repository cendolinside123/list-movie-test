//
//  MovieListViewModelImpl.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate enum PrevTask {
    case normalLoad
    case Search
}

class MovieListPresenterImpl: MovieListPresenter {
    private var disposableBag = DisposeBag()
    
    weak var delegate: MovieListDelegate?
    
    private var interaactor: MovieListInteractor = MovieListInteractorImpl()
    private var streamFetch: PublishSubject<(Bool, Bool, String?)> = PublishSubject()
    
    private var isRefetch: Bool = false
    private var isOnLoad: Bool = false
    private var currentPage: Int = 1
    private var getPrevTask: PrevTask = .normalLoad
    
    init() {
        
        interaactor.delegate = self
        streamFetch
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .filter({ [weak self] _, _, _ in
                if self?.interaactor.isOnLoad != false {
                    return false
                } else {
                    return true
                }
            })
            .subscribe(onNext: { [weak self] (isFirstInit, isRefetch, keyWord) in
                self?.delegate?.onLoading()
                if isFirstInit {
                    self?.interaactor.firstInitials()
                } else {
                    if let keyWord, keyWord != "" {
                        self?.interaactor.fetchMovie(keyWord: keyWord, isRefetch: isRefetch)
                        self?.getPrevTask = .Search
                    } else {
                        self?.interaactor.fetchMovie(isReFetch: isRefetch)
                        self?.getPrevTask = .normalLoad
                    }
                }
            }).disposed(by: disposableBag)
    }
    
    
    func firstInitials() {
        currentPage = 1
        getPrevTask = .normalLoad
        streamFetch.onNext((true, false, nil))
    }
    
    func fetchMovie(isReFetch: Bool) {
        
        var getReFetch = isReFetch
        
        if getPrevTask != .normalLoad {
            getReFetch = true
        }
        
        streamFetch.onNext((false, getReFetch, nil))
    }
    
    func fetchMovie(keyWord: String, isRefetch: Bool) {
        
        var getReFetch = isRefetch
        
        if getPrevTask != .Search {
            getReFetch = true
        }
        
        streamFetch.onNext((false, getReFetch, keyWord))
    }
}

extension MovieListPresenterImpl: MovieListIteratoract {
    func onSuccess(newData: [MovieEntity]) {
        self.delegate?.onEndLoading()
        self.delegate?.onSuccess(newData: newData)
    }
    
    func onError(error: Error) {
        self.delegate?.onEndLoading()
        self.delegate?.onError(error: error)
    }
    
}

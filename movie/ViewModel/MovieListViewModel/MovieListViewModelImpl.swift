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

class MovieListViewModelImpl: DummyMovielistVM<[MovieModel]> {
    private var disposableBag = DisposeBag()
    @Service private var useCaseMovieList: MovieUseCase
    @Service private var useCaseLanguage: LanguageUseCase
    @Service private var useCaseGenre: GenreUseCase
    
    private var streamFetch: PublishSubject<(Bool, Bool, String?)> = PublishSubject()
    
    private var isRefetch: Bool = false
    private var isOnLoad: Bool = false
    private var currentPage: Int = 1
    private var getPrevTask: PrevTask = .normalLoad
    
    override init() {
        super.init()
        streamFetch
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .filter({ [weak self] _, _, _ in
                if self?.isOnLoad != false {
                    return false
                } else {
                    return true
                }
            })
            .subscribe(onNext: { [weak self] (isFirstInit, isRefetch, keyWord) in
                if isFirstInit {
                    self?.firstInitLoad()
                } else {
                    if let keyWord {
                        self?.doSearchMovie(isRefetch: isRefetch, keyword: keyWord)
                    } else {
                        self?.doFetchMovie(isRefetch: isRefetch)
                    }
                }
            }).disposed(by: disposableBag)
        
        
    }
    
    
    override func firstInitials() {
        currentPage = 1
        getPrevTask = .normalLoad
        streamFetch.onNext((true, false, nil))
    }
    
    override func fetchMovie(isReFetch: Bool) {
        
        var getReFetch = isReFetch
        
        if getPrevTask != .normalLoad {
            getReFetch = true
        }
        
        streamFetch.onNext((false, getReFetch, nil))
    }
    
    override func fetchMovie(keyWord: String, isRefetch: Bool) {
        
        var getReFetch = isRefetch
        
        if getPrevTask != .Search {
            getReFetch = true
        }
        
        streamFetch.onNext((false, getReFetch, keyWord))
    }
}

extension MovieListViewModelImpl {
    private func firstInitLoad() {
        let useCaseLanguage = self.useCaseLanguage
        let useCaseGenre = self.useCaseGenre
        let useCaseMovieList = self.useCaseMovieList
        let getCurrentPage = self.currentPage
        isOnLoad = true
        useCaseLanguage
            .doFetchLanguage()
            .catchAndReturn([])
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap({ (result) -> Single<[GenreModel]> in
                
                var listReqGenre: [Observable<GenreResponse>] = []
                
                for item in result {
                    
                    let fetchGenreMovie = useCaseGenre
                        .fetchListGenreMovie(language: item.iso639_1)
                        .asObservable()
                        .catch({ _ in
                            return Observable.empty()
                        })
                    let fetchGenreTV = useCaseGenre
                        .fetchListGenreTV(language: item.iso639_1)
                        .asObservable()
                        .catch({ _ in
                            return Observable.empty()
                        })
                    listReqGenre.append(fetchGenreMovie)
                    listReqGenre.append(fetchGenreTV)
                }
                let doAllReq = Observable
                    .zip(listReqGenre)
                    .asSingle()
                    .map({ (result) -> [GenreModel] in
                        var listGenre: [GenreModel] = []
                        
                        for item in result {
                            listGenre += item.genres
                        }
                        
                        let doFilter = Array(Set(listGenre))
                        Constant.listStoredGenre = doFilter
                        return doFilter
                    })
                
                return doAllReq
            })
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap({ (_) -> Single<(MovieItemResponse)> in
                
                let fetchMovieList =  useCaseMovieList
                    .fetchMovie(isAdultAllow: true, page: getCurrentPage)
                return fetchMovieList
            })
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (movieResponse) -> [MovieModel] in
                
                var listMovie: [MovieModel] = []
                
                for item in movieResponse.results {
                    listMovie.append(item.toMovieModel())
                }
                
                return listMovie
            })
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                self?.currentPage += 1
                self?.delegate?.onEndLoading()
                if self?.listMovie == nil {
                    self?.listMovie = result
                } else {
                    self?.listMovie! += result
                }
                self?.delegate?.onSuccess()
                self?.isOnLoad = false
            }, onFailure: { [weak self] error in
                self?.delegate?.onEndLoading()
                self?.delegate?.onError(error: error)
            }).disposed(by: disposableBag)
    }
    
    private func doFetchMovie(isRefetch: Bool) {
        let useCaseMovieList = self.useCaseMovieList
        
        isOnLoad = true
        
        if isRefetch {
            self.currentPage = 1
        }
        self.getPrevTask = .normalLoad
        let currentPage = self.currentPage
        
        useCaseMovieList
            .fetchMovie(isAdultAllow: true, page: currentPage)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (movieResponse) -> [MovieModel] in
                
                var listMovie: [MovieModel] = []
                
                for item in movieResponse.results {
                    listMovie.append(item.toMovieModel())
                }
                
                return listMovie
            })
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ [weak self] (result) -> [MovieModel] in
                return self?.doFilterDuplicate(newData: result) ?? []
            })
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                self?.currentPage += 1
                self?.delegate?.onEndLoading()
                if isRefetch {
                    self?.listMovie = result
                } else {
                    if self?.listMovie == nil {
                        self?.listMovie = result
                    } else {
                        self?.listMovie! += result
                    }
                }
                
                self?.delegate?.onSuccess()
                self?.isOnLoad = false
            }, onFailure: { [weak self] error in
                self?.delegate?.onEndLoading()
                self?.delegate?.onError(error: error)
            }).disposed(by: disposableBag)
        
    }
    
    private func doSearchMovie(isRefetch: Bool, keyword: String) {
        let useCaseMovieList = self.useCaseMovieList
        
        isOnLoad = true
        
        if isRefetch {
            self.currentPage = 1
        }
        self.getPrevTask = .normalLoad
        let currentPage = self.currentPage
        
        useCaseMovieList
            .searchMovie(keyWord: keyword, isAdultAllow: true, page: currentPage)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (movieResponse) -> [MovieModel] in
                
                var listMovie: [MovieModel] = []
                
                for item in movieResponse.results {
                    listMovie.append(item.toMovieModel())
                }
                
                return listMovie
            })
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ [weak self] (result) -> [MovieModel] in
                return self?.doFilterDuplicate(newData: result) ?? []
            })
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                self?.currentPage += 1
                self?.delegate?.onEndLoading()
                if isRefetch {
                    self?.listMovie = result
                } else {
                    if self?.listMovie == nil {
                        self?.listMovie = result
                    } else {
                        self?.listMovie! += result
                    }
                }
                
                self?.delegate?.onSuccess()
                self?.isOnLoad = false
            }, onFailure: { [weak self] error in
                self?.delegate?.onEndLoading()
                self?.delegate?.onError(error: error)
            }).disposed(by: disposableBag)
        
    }
    
    private func doFilterDuplicate(newData: [MovieModel]) -> [MovieModel] {
        
        let oldData = Set(self.listMovie ?? [])
        let getNewData = Set(newData)
        let difference = getNewData.subtracting(oldData)
        
        return Array(difference)
    }
    
}

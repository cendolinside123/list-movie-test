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
    @Service private var useCaseGenreLocal: GenreLocalUseCase
    @Service private var usecaseMovieLocal: MovieLocalUseCase
    
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
                    if let keyWord, keyWord != "" {
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
        let localGenreUseCase = self.useCaseGenreLocal
        let localMovieUsecase = self.usecaseMovieLocal
        var cacheMovie: [MovieModel] = []
        isOnLoad = true
        delegate?.onLoading()
        
        // assumsion minimum genre is 19
        localGenreUseCase
            .fetchAllGenre()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap( { (result) -> Single<[GenreModel]> in
                
                if result.count >= 19 {
                    
                    var listGenre = [GenreModel]()
                    
                    for item in result {
                        if let getGenre = item.toNormalModel() {
                            listGenre.append(getGenre)
                        }
                    }
                    Constant.listStoredGenre = listGenre
                    return Single.just(listGenre)
                } else {
                    return useCaseLanguage
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
                                .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                                .map({ (result) -> [GenreModel] in
                                    var listGenre: [GenreModel] = []
                                    
                                    for item in result {
                                        listGenre += item.genres
                                    }
                                    
                                    let doFilter = Array(Set(listGenre))
                                    Constant.listStoredGenre = doFilter
                                    return doFilter
                                }).flatMap({ (result) -> Single<[GenreModel]> in
                                    
                                    var doInputGenre: [Completable] = []
                                    
                                    for item in result {
                                        let doTask = localGenreUseCase
                                            .addGenre(value: item)
                                            .catch({ _ in
                                                return Completable.empty()
                                            })
                                        doInputGenre.append(doTask)
                                    }
                                    
                                    return Completable
                                        .zip(doInputGenre)
                                        .andThen(Single.just(result))
                                        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                                })
                            
                            return doAllReq
                        })
                }
            }).observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap({ (_) -> Single<(MovieItemResponse, [Movie])> in
                
                let getCache = localMovieUsecase
                    .getAllMovie()
                    .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                    .flatMap({ listItem -> Single<[Movie]> in
                        
                        var listMovieModel: [MovieModel] = []
                        
                        for item in listItem {
                            if let getMovie = item.toNormalModel() {
                                listMovieModel.append(getMovie)
                            }
                        }
                        cacheMovie = listMovieModel
                        
                        return Single.just(listItem)
                    }).catch({ _ in
                        return Single.just([])
                    })
                
                let fetchMovieList =  useCaseMovieList
                    .fetchMovie(isAdultAllow: true, page: getCurrentPage)
                return Single.zip(fetchMovieList, getCache)
            })
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (movieResponse, listCache) -> ([MovieModel], [Movie]) in
                
                var listMovie: [MovieModel] = []
                
                for item in movieResponse.results {
                    listMovie.append(item.toMovieModel())
                }
                
                return (listMovie, listCache)
            })
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap({ (listMovie, listCache) -> Single<[MovieModel]> in
                let onlineData = listMovie
                
                var listMovieModel: [MovieModel] = []
                
                for item in listCache {
                    if let getMovie = item.toNormalModel() {
                        listMovieModel.append(getMovie)
                    }
                }
                
                let cleaningLocalData = Set(listMovieModel)
                let cleaningOnlineData = Set(onlineData)
                
                let getDifference = cleaningOnlineData.subtracting(cleaningLocalData)
                
                var listTask: [Completable] = []
                
                for item in listMovie {
                    let doTask = localMovieUsecase
                        .inputMovie(value: item)
                        .catch({ _ in
                            return Completable.empty()
                        })
                    listTask.append(doTask)
                }
                
                return Completable
                    .zip(listTask)
                    .andThen(Single.just(onlineData))
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            })
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                self?.currentPage += 1
                self?.delegate?.onEndLoading()
                if self?.listMovie == nil || self?.currentPage == 1 {
                    self?.listMovie = result
                } else {
                    self?.listMovie! += result
                }
                self?.delegate?.onSuccess()
                self?.isOnLoad = false
            }, onFailure: { [weak self] error in
                self?.delegate?.onEndLoading()
                self?.delegate?.onError(error: error)
                if cacheMovie.count > 0 {
                    self?.listMovie = cacheMovie
                    self?.delegate?.onSuccess()
                }
            }).disposed(by: disposableBag)
    }
    
    private func doFetchMovie(isRefetch: Bool) {
        let useCaseMovieList = self.useCaseMovieList
        let localMovieUsecase = self.usecaseMovieLocal
        
        isOnLoad = true
        
        if isRefetch {
            self.currentPage = 1
        }
        self.getPrevTask = .normalLoad
        let currentPage = self.currentPage
        delegate?.onLoading()
        let getLocalData = localMovieUsecase
            .getAllMovie()
            .catchAndReturn([])
        
        let fetchOnlineData = useCaseMovieList
            .fetchMovie(isAdultAllow: true, page: currentPage)
        
        Single.zip(getLocalData, fetchOnlineData)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (localCache, movieResponse) -> ([MovieModel], [Movie]) in
                
                var listMovie: [MovieModel] = []
                
                for item in movieResponse.results {
                    listMovie.append(item.toMovieModel())
                }
                
                return (listMovie, localCache)
            })
            .flatMap({ (listMovie, listCache) -> Single<[MovieModel]> in
                let onlineData = listMovie
                
                var listMovieModel: [MovieModel] = []
                
                for item in listCache {
                    if let getMovie = item.toNormalModel() {
                        listMovieModel.append(getMovie)
                    }
                }
                
                let cleaningLocalData = Set(listMovieModel)
                let cleaningOnlineData = Set(onlineData)
                
                let getDifference = cleaningOnlineData.subtracting(cleaningLocalData)
                
                var listTask: [Completable] = []
                
                for item in listMovie {
                    let doTask = localMovieUsecase
                        .inputMovie(value: item)
                        .catch({ _ in
                            return Completable.empty()
                        })
                    listTask.append(doTask)
                }
                
                return Completable
                    .zip(listTask)
                    .andThen(Single.just(onlineData))
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            })
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ [weak self] (result) -> [MovieModel] in
                if !isRefetch {
                    return self?.doFilterDuplicate(newData: result) ?? []
                } else {
                    return result
                }
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
        let localMovieUsecase = self.usecaseMovieLocal
        
        isOnLoad = true
        
        if isRefetch {
            self.currentPage = 1
        }
        self.getPrevTask = .Search
        let currentPage = self.currentPage
        delegate?.onLoading()
        
        let getLocalData = localMovieUsecase
            .getAllMovie()
            .catchAndReturn([])
        
        let fetchOnlineData = useCaseMovieList
            .searchMovie(keyWord: keyword, isAdultAllow: true, page: currentPage)
        
        Single.zip(getLocalData, fetchOnlineData)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (localCache, movieResponse) -> ([MovieModel], [Movie]) in
                
                var listMovie: [MovieModel] = []
                
                for item in movieResponse.results {
                    listMovie.append(item.toMovieModel())
                }
                
                return (listMovie, localCache)
            })
            .flatMap({ (listMovie, listCache) -> Single<[MovieModel]> in
                let onlineData = listMovie
                
                var listMovieModel: [MovieModel] = []
                
                for item in listCache {
                    if let getMovie = item.toNormalModel() {
                        listMovieModel.append(getMovie)
                    }
                }
                
                let cleaningLocalData = Set(listMovieModel)
                let cleaningOnlineData = Set(onlineData)
                
                let getDifference = cleaningOnlineData.subtracting(cleaningLocalData)
                
                var listTask: [Completable] = []
                
                for item in listMovie {
                    let doTask = localMovieUsecase
                        .inputMovie(value: item)
                        .catch({ _ in
                            return Completable.empty()
                        })
                    listTask.append(doTask)
                }
                
                return Completable
                    .zip(listTask)
                    .andThen(Single.just(onlineData))
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            })
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ [weak self] (result) -> [MovieModel] in
                if !isRefetch {
                    return self?.doFilterDuplicate(newData: result) ?? []
                } else {
                    return result
                }
                
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

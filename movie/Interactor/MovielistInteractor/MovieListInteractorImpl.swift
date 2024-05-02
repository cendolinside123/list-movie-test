//
//  MovieListInteractorImpl.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import RxSwift
import RxCocoa


fileprivate enum PrevTask {
    case normalLoad
    case Search
}

class MovieListInteractorImpl {
    weak var delegate: MovieListIteratoract?
    private var disposableBag = DisposeBag()
    @Service private var useCaseMovieList: MovieUseCase
    @Service private var useCaseLanguage: LanguageUseCase
    @Service private var useCaseGenre: GenreUseCase
    @Service private var useCaseGenreLocal: GenreLocalUseCase
    @Service private var usecaseMovieLocal: MovieLocalUseCase
    private var currentPage: Int = 1
    
    
    private var listMovie: [MovieEntity] = []
    var isOnLoad: Bool = false
}

extension MovieListInteractorImpl: MovieListInteractor {
    
    func firstInitials() {
        let useCaseLanguage = self.useCaseLanguage
        let useCaseGenre = self.useCaseGenre
        let useCaseMovieList = self.useCaseMovieList
        let getCurrentPage = self.currentPage
        let localGenreUseCase = self.useCaseGenreLocal
        let localMovieUsecase = self.usecaseMovieLocal
        var cacheMovie: [MovieEntity] = []
        isOnLoad = true
        
        // assumsion minimum genre is 19
        localGenreUseCase
            .fetchAllGenre()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap( { (result) -> Single<[GenreEntity]> in
                
                if result.count >= 19 {
                    
                    var listGenre = [GenreEntity]()
                    
                    for item in result {
                        if let getGenre = item.toNormalEntity() {
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
                        .flatMap({ (result) -> Single<[GenreEntity]> in
                            
                            var listReqGenre: [Single<GenreResponse>] = []
                            
                            for item in result {
                                
                                let fetchGenreMovie = useCaseGenre
                                    .fetchListGenreMovie(language: item.iso639_1)
                                    .catch({ _ in
//                                        return Single.never()
                                        return Single.just(GenreResponse(genres: []))
                                    })
                                let fetchGenreTV = useCaseGenre
                                    .fetchListGenreTV(language: item.iso639_1)
                                    .catch({ _ in
                                        return Single.just(GenreResponse(genres: []))
                                    })
                                listReqGenre.append(fetchGenreMovie)
                                listReqGenre.append(fetchGenreTV)
                            }
                            let doAllReq = Single
                                .zip(listReqGenre)
                                .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                                .map({ (result) -> [GenreEntity] in
                                    var listGenre: [GenreEntity] = []
                                    
                                    for item in result {
                                        listGenre += item.genres
                                    }
                                    
                                    let doFilter = Array(Set(listGenre))
                                    Constant.listStoredGenre = doFilter
                                    return doFilter
                                }).flatMap({ (result) -> Single<[GenreEntity]> in
                                    
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
                        
                        var listMovieModel: [MovieEntity] = []
                        
                        for item in listItem {
                            if let getMovie = item.toNormalEntity() {
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
            .map({ (movieResponse, listCache) -> ([MovieEntity], [Movie]) in
                
                var listMovie: [MovieEntity] = []
                
                for item in movieResponse.results {
                    listMovie.append(item.toMovieModel())
                }
                
                return (listMovie, listCache)
            })
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap({ (listMovie, listCache) -> Single<[MovieEntity]> in
                let onlineData = listMovie
                
                var listMovieModel: [MovieEntity] = []
                
                for item in listCache {
                    if let getMovie = item.toNormalEntity() {
                        listMovieModel.append(getMovie)
                    }
                }
                
                let cleaningLocalData = Set(listMovieModel)
                let cleaningOnlineData = Set(onlineData)
                
                let getDifference = cleaningOnlineData.subtracting(cleaningLocalData)
                
                var listTask: [Completable] = []
                
                for item in getDifference {
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
                self?.listMovie += result
                self?.delegate?.onSuccess(newData: (self?.listMovie ?? []))
                self?.isOnLoad = false
            }, onFailure: { [weak self] error in
                self?.delegate?.onError(error: error)
                if cacheMovie.count > 0 {
                    self?.listMovie = cacheMovie
                    self?.delegate?.onSuccess(newData: (self?.listMovie ?? []))
                }
            }).disposed(by: disposableBag)
    }
    
    func fetchMovie(isReFetch: Bool) {
        let useCaseMovieList = self.useCaseMovieList
        let localMovieUsecase = self.usecaseMovieLocal
        
        isOnLoad = true
        
        if isReFetch {
            self.currentPage = 1
        }
        
        let currentPage = self.currentPage
        let getLocalData = localMovieUsecase
            .getAllMovie()
            .catchAndReturn([])
        
        let fetchOnlineData = useCaseMovieList
            .fetchMovie(isAdultAllow: true, page: currentPage)
        
        Single.zip(getLocalData, fetchOnlineData)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (localCache, movieResponse) -> ([MovieEntity], [Movie]) in
                
                var listMovie: [MovieEntity] = []
                
                for item in movieResponse.results {
                    listMovie.append(item.toMovieModel())
                }
                
                return (listMovie, localCache)
            })
            .flatMap({ (listMovie, listCache) -> Single<[MovieEntity]> in
                let onlineData = listMovie
                
                var listMovieModel: [MovieEntity] = []
                
                for item in listCache {
                    if let getMovie = item.toNormalEntity() {
                        listMovieModel.append(getMovie)
                    }
                }
                
                let cleaningLocalData = Set(listMovieModel)
                let cleaningOnlineData = Set(onlineData)
                
                let getDifference = cleaningOnlineData.subtracting(cleaningLocalData)
                
                var listTask: [Completable] = []
                
                for item in getDifference {
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
            .map({ [weak self] (result) -> [MovieEntity] in
                if !isReFetch {
                    return self?.doFilterDuplicate(newData: result) ?? []
                } else {
                    return result
                }
            })
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                self?.currentPage += 1
                
                if !isReFetch {
                    self?.listMovie += result
                } else {
                    self?.listMovie = result
                }
                
                self?.delegate?.onSuccess(newData: (self?.listMovie ?? []))
                self?.isOnLoad = false
            }, onFailure: { [weak self] error in
                self?.delegate?.onError(error: error)
            }).disposed(by: disposableBag)
        
    }
    
    func fetchMovie(keyWord: String, isRefetch: Bool) {
        let useCaseMovieList = self.useCaseMovieList
        let localMovieUsecase = self.usecaseMovieLocal
        
        isOnLoad = true
        
        if isRefetch {
            self.currentPage = 1
        }
        
        let currentPage = self.currentPage
        
        let getLocalData = localMovieUsecase
            .getAllMovie()
            .catchAndReturn([])
        
        let fetchOnlineData = useCaseMovieList
            .searchMovie(keyWord: keyWord, isAdultAllow: true, page: currentPage)
        
        Single.zip(getLocalData, fetchOnlineData)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (localCache, movieResponse) -> ([MovieEntity], [Movie]) in
                
                var listMovie: [MovieEntity] = []
                
                for item in movieResponse.results {
                    listMovie.append(item.toMovieModel())
                }
                
                return (listMovie, localCache)
            })
            .flatMap({ (listMovie, listCache) -> Single<[MovieEntity]> in
                let onlineData = listMovie
                
                var listMovieModel: [MovieEntity] = []
                
                for item in listCache {
                    if let getMovie = item.toNormalEntity() {
                        listMovieModel.append(getMovie)
                    }
                }
                
                let cleaningLocalData = Set(listMovieModel)
                let cleaningOnlineData = Set(onlineData)
                
                let getDifference = cleaningOnlineData.subtracting(cleaningLocalData)
                
                var listTask: [Completable] = []
                
                for item in getDifference {
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
            .map({ [weak self] (result) -> [MovieEntity] in
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
                if !isRefetch {
                    self?.listMovie += result
                } else {
                    self?.listMovie = result
                }
                self?.delegate?.onSuccess(newData: result)
                self?.isOnLoad = false
            }, onFailure: { [weak self] error in
                self?.delegate?.onError(error: error)
            }).disposed(by: disposableBag)
        
    }
    
}

extension MovieListInteractorImpl {
    private func doFilterDuplicate(newData: [MovieEntity]) -> [MovieEntity] {
        
        let getOldData = Set(self.listMovie)
        let getNewData = Set(newData)
        let difference = getNewData.subtracting(getOldData)
        
        return Array(difference)
    }
}

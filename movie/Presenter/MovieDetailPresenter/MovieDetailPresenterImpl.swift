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
    @Service private var useCaseMovieList: MovieUseCase
    @Service private var useCaseListCast: CastUseCase
    @Service private var usecaseMovieLocal: MovieLocalUseCase
    @Service private var useCaseCastLocal: CastLocalUseCase
    
}

extension MovieDetailPresenterImpl: MovieDetailPresenter {
    func loadMovieDetail(movieID: Int) {
        
        delegate?.onLoading()
        let castUsecaseLocal = self.useCaseCastLocal
        let detailMovieUscaseLocal = self.usecaseMovieLocal
        
        let loadDetail =  useCaseMovieList
            .fetchMovieDetail(movieID: movieID)
            .asObservable()
        
        let fetchCast = useCaseListCast
            .fetchMovieCredits(movieID: movieID)
            .asObservable()
            .catch({ _ in
                return Observable.empty()
            })
        
        let fetchOnline = Observable.zip(loadDetail, fetchCast)
            .asSingle()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (detailResponse, castResponse) -> (MovieDetailModel, [CastModel]) in
                
                var getDetail = detailResponse.toMovieDetailModel()
                
                let getSize =  NSString(string: getDetail.overview).boundingRect(
                    with:
                        CGSize(
                            width:
                                (
                                    UIScreen.main.bounds.width - (2 * 20)
                                ),
                            height: CGFloat.greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil
                )
                
                
                let totalHeight = getSize.height + (2 * 20)
                
                getDetail.overViewSize = CGSize(width: getSize.width, height: totalHeight)
                
                return (getDetail, castResponse.cast)
            })
            
        
        usecaseMovieLocal
            .getMovie(movieID: movieID)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap({ result -> Single<(MovieDetailModel, [CastModel])> in
                
                if let getResult = result  {
                    if let getDetail = getResult.toDetail,
                       var getDetailModel = getDetail.toNormalModel() {
                        let listCast = (getResult.toCast?.allObjects as? [Cast])
                        var listAllCast: [CastModel] = []
                        
                        for item in (listCast ?? []) {
                            if let getCast = item.toNormalModel() {
                                listAllCast.append(getCast)
                            }
                        }
                        
                        let getSize =  NSString(string: getDetailModel.overview).boundingRect(
                            with:
                                CGSize(
                                    width:
                                        (
                                            UIScreen.main.bounds.width - (2 * 20)
                                        ),
                                    height: CGFloat.greatestFiniteMagnitude),
                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                            context: nil
                        )
                        
                        
                        let totalHeight = getSize.height + (2 * 20)
                        
                        getDetailModel.overViewSize = CGSize(width: getSize.width, height: totalHeight)
                        if listAllCast.count > 0 {
                            return Single.zip(Single.just(getDetailModel), Single.just(listAllCast))
                        } else {
                            let getCast = fetchCast
                                .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                                .flatMap({ castResponse -> Single<[CastModel]> in
                                    return castUsecaseLocal
                                        .doInputCast(movie: getResult, value: castResponse.cast)
                                        .catch({ _ in
                                            return Completable.empty()
                                        })
                                        .andThen(Single.just(castResponse.cast))
                                }).asSingle()
                            return Single.zip(Single.just(getDetailModel), getCast)
                        }
                    } else {
                        return fetchOnline
                            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                            .flatMap({ (detailMovie, listCast) -> Single<(MovieDetailModel, [CastModel])> in
                                
                                return detailMovieUscaseLocal
                                    .inputMovieDetail(movie: getResult, valueDetail: detailMovie, cast: listCast)
                                    .catch({ _ in
                                        return Completable.empty()
                                    }).andThen(Single.zip(Single.just(detailMovie), Single.just(listCast)))
                            })
                    }
                    
                } else {
                    return fetchOnline
                }
            })
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detailMovie, listCast in
                
                self?.delegate?.onEndLoading()
                self?.delegate?.onSuccess(value: (detailMovie, listCast))
                
            }, onFailure: { [weak self] error in
                self?.delegate?.onEndLoading()
                self?.delegate?.onError(error: error)
            }).disposed(by: disposableBag)
    }
}

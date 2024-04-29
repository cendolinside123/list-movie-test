//
//  MovieDetailViewModelImpl.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import RxSwift

class MovieDetailViewModelImpl: DummyMovieDetailVM<(MovieDetailModel, [CastModel])> {
    
    private var disposableBag = DisposeBag()
    @Service private var useCaseMovieList: MovieUseCase
    @Service private var useCaseListCast: CastUseCase
    @Service private var usecaseMovieLocal: MovieLocalUseCase
    
    override func loadMovieDetail(movieID: Int) {
        
        delegate?.onLoading()
        
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
            .flatMap({ result -> Single<(MovieDetailModel, [CastModel])> in
                
                if let getDetail = result?.toDetail, 
                    let listCast = (result?.toCast?.allObjects as? [Cast]),
                    var getDetailModel = getDetail.toNormalModel() {
                    
                    for item in listCast {
                        if let getCast = item.toNormalModel() {
                            
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
                    
//                    getDetail.overViewSize = CGSize(width: getSize.width, height: totalHeight)
//                    return Single.zip(Single.just(getDetailModel), Single.just(getCast))
                }
                
                
                return fetchOnline
            })
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detailMovie, listCast in
                
                self?.delegate?.onEndLoading()
                self?.movieInformation = (detailMovie, listCast)
                self?.delegate?.onSuccess()
                
            }, onFailure: { [weak self] error in
                self?.delegate?.onEndLoading()
                self?.delegate?.onError(error: error)
            }).disposed(by: disposableBag)
    }
    
}

//
//  MovieDetailUseCaseImpl.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import Alamofire
import RxSwift

struct MovieDetailUseCaseImpl {
    
}

extension MovieDetailUseCaseImpl: MovieDetailUseCase {
    func fetchMovieDetail(movieID: Int) -> RxSwift.Single<MovieDetailOnlineModel> {
        return Single.create(subscribe: { emmiter in
            if let token = Bundle.main.infoDictionary?["API_READ_ACCESS_TOKEN"] as? String {
                AF.request("https://api.themoviedb.org/3/movie/\(movieID)}",
                           method:  .get,
                           parameters: nil,
                           encoding: URLEncoding.default,
                           headers: ["Authorization":"Bearer \(token)"])
                .responseData(completionHandler: { response in
                    
                    switch response.result {
                    case .success(let data):
                        do {
                            let getData = try JSONDecoder().decode(MovieDetailOnlineModel.self, from: data)
                            emmiter(.success(getData))
                        } catch let error as NSError {
                            emmiter(.failure(error))
                        }
                    case .failure(let error):
                        emmiter(.failure(error))
                    }
                    
                })
            } else {
                emmiter(.failure(ErrorResponse.CustomError("failed get auth")))
            }
            return Disposables.create()
        }).retry(3)
    }
    
    
}


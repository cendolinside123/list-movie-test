//
//  MovieDataSourceImpl.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import Alamofire
import RxSwift

struct MovieUseCaseImpl {
    
}

extension MovieUseCaseImpl: MovieUseCase {
    
    func searchMovie(keyWord: String, isAdultAllow: Bool, page: Int) -> RxSwift.Single<MovieItemResponse> {
        return Single.create(subscribe: { emmiter in
            
            
            if let token = Bundle.main.infoDictionary?["API_READ_ACCESS_TOKEN"] as? String {
                
                let inputParams: [String: Any] = [
                    "query": keyWord,
                    "include_adult": isAdultAllow,
                    "page": page
                ]
                
                AF.request("https://api.themoviedb.org/3/search/movie",
                           method:  .get,
                           parameters: inputParams,
                           encoding: URLEncoding.default,
                           headers: ["Authorization":"Bearer \(token)"])
                .responseData(completionHandler: { response in
                    
                    switch response.result {
                    case .success(let data):
                        do {
                            let getData = try JSONDecoder().decode(MovieItemResponse.self, from: data)
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
    
    func fetchMovie(isAdultAllow: Bool, page: Int) -> RxSwift.Single<MovieItemResponse> {
        return Single.create(subscribe: { emmiter in
            
            let inputParams: [String: Any] = [
                "include_adult": isAdultAllow,
                "page": page
            ]
            
            if let token = Bundle.main.infoDictionary?["API_READ_ACCESS_TOKEN"] as? String {
                AF.request("https://api.themoviedb.org/3/discover/movie",
                           method:  .get,
                           parameters: inputParams,
                           encoding: URLEncoding.default,
                           headers: ["Authorization":"Bearer \(token)"])
                .responseData(completionHandler: { response in
                    
                    switch response.result {
                    case .success(let data):
                        do {
                            let getData = try JSONDecoder().decode(MovieItemResponse.self, from: data)
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
    
    func fetchMovieDetail(movieID: Int) -> RxSwift.Single<MovieDetailOnlineEntity> {
        return Single.create(subscribe: { emmiter in
            
            if let token = Bundle.main.infoDictionary?["API_READ_ACCESS_TOKEN"] as? String {
                AF.request("https://api.themoviedb.org/3/movie/\(movieID)",
                           method:  .get,
                           parameters: nil,
                           encoding: URLEncoding.default,
                           headers: ["Authorization":"Bearer \(token)"])
                .responseData(completionHandler: { response in
                    
                    switch response.result {
                    case .success(let data):
                        do {
                            let getData = try JSONDecoder().decode(MovieDetailOnlineEntity.self, from: data)
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

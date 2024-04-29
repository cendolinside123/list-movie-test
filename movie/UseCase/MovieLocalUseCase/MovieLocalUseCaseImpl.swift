//
//  MovieLocalUseCaseImpl.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData
import RxSwift

struct MovieLocalUseCaseImpl {
    
}

extension MovieLocalUseCaseImpl: MovieLocalUseCase {
    
    
    func inputMovie(value: MovieEntity) -> RxSwift.Completable {
        return Completable.create(subscribe: { emmiter in
            
            CoreDataStack.shared.doInBackground {
                do {
                    let context = CoreDataStack.shared.getPrivateContext()
                    let movieLocal = Movie(context: context)
                    movieLocal.adult = value.adult
                    movieLocal.title = value.title
                    movieLocal.backdropPath = value.backdropPath
                    movieLocal.genreIDS = value.genreIDS
                    movieLocal.id = Int64(value.id)
                    movieLocal.originalLanguage = value.originalLanguage
                    movieLocal.originalTitle = value.originalTitle
                    movieLocal.overview = value.overview
                    movieLocal.popularity = value.popularity
                    movieLocal.posterPath = value.posterPath
                    movieLocal.releaseDate = value.releaseDate
                    movieLocal.video = value.video
                    movieLocal.voteAverage = value.voteAverage
                    movieLocal.voteCount = Int64(value.voteCount)
                    try context.save()
                    emmiter(.completed)
                } catch let error as NSError {
                    emmiter(.error(error))
                }
            }
            
            return Disposables.create()
        })
    }
    
    func getMovie(movieID: Int) -> RxSwift.Single<Movie?> {
        return Single.create(subscribe: { emmiter in
            
            CoreDataStack.shared.doInBackground {
                do {
                    let fetchData = Movie.fetchRequest()
                    fetchData.predicate = NSPredicate(format: "%K == '\(movieID)'", (\Movie.id)._kvcKeyPathString!)
                    let doFetch = try CoreDataStack.shared.getPrivateContext()
                        .fetch(fetchData)
                    emmiter(.success(doFetch.first))
                    
                } catch let error as NSError {
                    emmiter(.failure(error))
                }
            }
            
            return Disposables.create()
        })
    }
    
    func getAllMovie() -> RxSwift.Single<[Movie]> {
        return Single.create(subscribe: { emmiter in
            
            CoreDataStack.shared.doInBackground {
                do {
                    let fetchData = Movie.fetchRequest()
                    
                    let doFetch = try CoreDataStack.shared.getPrivateContext()
                        .fetch(fetchData)
                    emmiter(.success(doFetch))
                    
                } catch let error as NSError {
                    emmiter(.failure(error))
                }
            }
            
            return Disposables.create()
        })
    }
    
    func inputMovieDetail(movie: Movie,
                          valueDetail: MovieDetailEntity,
                          cast: [CastEntity]) -> RxSwift.Completable {
        return Completable.create(subscribe: { emmiter in
            
            CoreDataStack.shared.doInBackground {
                do {
                    let context = CoreDataStack.shared.getPrivateContext()
                    let movieDetailLocal = MovieDetail(context: context)
                    movieDetailLocal.adult = valueDetail.adult
                    movieDetailLocal.backdropPath = valueDetail.backdropPath
                    
                    if let doEncodeBelongColleect = try? JSONEncoder().encode(valueDetail.belongsToCollection) {
                        movieDetailLocal.belongsToCollection = doEncodeBelongColleect
                    } else {
                        
                    }
                   
                    movieDetailLocal.budget = Int64(valueDetail.budget)
                    movieDetailLocal.genres = valueDetail.genres
                    movieDetailLocal.homepage = valueDetail.homepage
                    movieDetailLocal.id = Int64(valueDetail.id)
                    movieDetailLocal.imdbID = valueDetail.imdbID
                    movieDetailLocal.originalLanguage = valueDetail.originalLanguage
                    movieDetailLocal.originalTitle = valueDetail.originalTitle
                    if let doEncodeOriginCountry = try? JSONEncoder().encode(valueDetail.originCountry) {
                        movieDetailLocal.originCountry = doEncodeOriginCountry
                    }
                    
                    movieDetailLocal.overview = valueDetail.overview
                    movieDetailLocal.popularity = valueDetail.popularity
                    movieDetailLocal.posterPath = valueDetail.posterPath
                    if let doEncodeprodCompany = try? JSONEncoder().encode(valueDetail.productionCompanies) {
                        movieDetailLocal.productionCompanies = doEncodeprodCompany
                    }
                    
                    if let doEncodeProdCountry = try? JSONEncoder().encode(valueDetail.productionCountries) {
                        movieDetailLocal.productionCountries = doEncodeProdCountry
                    }
                    
                    movieDetailLocal.releaseDate = valueDetail.releaseDate
                    movieDetailLocal.revenue = Int64(valueDetail.revenue)
                    movieDetailLocal.runtime = Int64(valueDetail.runtime)
                    if let doEncodeSpokenLanguage = try? JSONEncoder().encode(valueDetail.spokenLanguages) {
                        movieDetailLocal.spokenLanguages = doEncodeSpokenLanguage
                    }
                    
                    movieDetailLocal.status = valueDetail.status
                    movieDetailLocal.tagline = valueDetail.tagline
                    movieDetailLocal.title = valueDetail.title
                    movieDetailLocal.video = valueDetail.video
                    movieDetailLocal.voteAverage = valueDetail.voteAverage
                    movieDetailLocal.voteCount = Int64(valueDetail.voteCount)
                    movieDetailLocal.toItem = movie
                    movie.toDetail = movieDetailLocal
                    
                    if let castConnection = movie.toCast?.mutableCopy() as? NSMutableSet {
                        for item in cast {
                            let castLocal = Cast(context: context)
                            if let castID = item.castID {
                                castLocal.castID = Int64(castID)
                            }
                            castLocal.adult = item.adult
                            castLocal.character = item.character
                            castLocal.creditID = item.creditID
                            castLocal.department = item.department
                            castLocal.gender = Int64(item.gender)
                            castLocal.id = Int64(item.id)
                            castLocal.job = item.job
                            castLocal.knownForDepartment = item.knownForDepartment
                            if let orderNumber = item.order {
                                castLocal.order = Int64(orderNumber)
                            }
                            castLocal.originalName = item.originalName
                            castLocal.popularity = item.popularity
                            castLocal.profilePath = item.profilePath
                            castLocal.name = item.name
                            castLocal.toitem = movie
                            castConnection.add(castLocal)
                        }
                    }
                    try context.save()
                    emmiter(.completed)
                } catch let error as NSError {
                    emmiter(.error(error))
                }
            }
            
            return Disposables.create()
            
        })
    }
    
    func getMovieDetail(movieID: Int) -> RxSwift.Single<MovieDetail?> {
        return Single.create(subscribe: { emmiter in
            
            CoreDataStack.shared.doInBackground {
                do {
                    let fetchData = MovieDetail.fetchRequest()
                    fetchData.predicate = NSPredicate(format: "%K == '\(movieID)'", (\MovieDetail.id)._kvcKeyPathString!)
                    let doFetch = try CoreDataStack.shared.getPrivateContext()
                        .fetch(fetchData)
                    emmiter(.success(doFetch.first))
                    
                } catch let error as NSError {
                    emmiter(.failure(error))
                }
            }
            
            return Disposables.create()
        })
    }
    
}

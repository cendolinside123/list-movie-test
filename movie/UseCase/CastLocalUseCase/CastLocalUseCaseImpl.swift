//
//  CastLocalUseCaseImpl.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import RxSwift
import CoreData

struct CastLocalUseCaseImpl {
    
}

extension CastLocalUseCaseImpl: CastLocalUseCase {
    func doInputCast(movie: Movie, value: [CastEntity]) -> RxSwift.Completable {
        return Completable.create(subscribe: { emmiter in
            
            CoreDataStack.shared.doInBackground {
                do {
                    let context = CoreDataStack.shared.getPrivateContext()
                    if let castConnection = movie.toCast?.mutableCopy() as? NSMutableSet {
                        for item in value {
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
    
    
}

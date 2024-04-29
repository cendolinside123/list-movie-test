//
//  GenreLocalUseCaseImpl.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData
import RxSwift

struct GenreLocalUseCaseImpl {
    
}

extension GenreLocalUseCaseImpl: GenreLocalUseCase {
    func addGenre(value: GenreEntity) -> RxSwift.Completable {
        return Completable.create(subscribe: { emmiter in
            
            CoreDataStack.shared.doInBackground {
                do {
                    let context = CoreDataStack.shared.getPrivateContext()
                    let genre = Genre(context: context)
                    genre.id = Int64(value.id)
                    genre.name = value.name
                    try context.save()
                    emmiter(.completed)
                } catch let error as NSError {
                    emmiter(.error(error))
                }
                
            }
            
            return Disposables.create()
        })
    }
    
    func fetchAllGenre() -> RxSwift.Single<[Genre]> {
        return Single.create(subscribe: { emmiter in
            
            CoreDataStack.shared.doInBackground {
                do {
                    let fetchData = Genre.fetchRequest()
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
    
    
}

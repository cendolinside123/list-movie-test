//
//  MovieListTest.swift
//  movieTests
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import XCTest
@testable import movie

class MovieListTest: XCTestCase {
    
    
    override class func setUp() {
        CoreDataStack.shared.isTestOnly = true
        CoreDataStack.shared.doTestSetup()
        ServiceContainer.register(type: GenreUseCase.self, GenreUseCaseImpl())
        ServiceContainer.register(type: LanguageUseCase.self, LanguageUseCaseImpl())
        ServiceContainer.register(type: CastUseCase.self, CastUseCaseImpl())
        ServiceContainer.register(type: MovieUseCase.self, MovieUseCaseImpl())
        ServiceContainer.register(type: MovieLocalUseCase.self, MovieLocalUseCaseImpl())
        ServiceContainer.register(type: GenreLocalUseCase.self, GenreLocalUseCaseImpl())
        ServiceContainer.register(type: CastLocalUseCase.self, CastLocalUseCaseImpl())
    }
    
    func testFirstLoad() {
        
    }
    
    func testFetchNewPage() {
        
    }
    
    func testSearchMovie() {
        
    }
    
}

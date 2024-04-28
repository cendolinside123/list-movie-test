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
        ServiceContainer.register(type: GenreUseCase.self, GenreUseCaseImpl())
        ServiceContainer.register(type: LanguageUseCase.self, LanguageUseCaseImpl())
        ServiceContainer.register(type: CastUseCase.self, CastUseCaseImpl())
        ServiceContainer.register(type: MovieUseCase.self, MovieUseCaseImpl())
    }
    
    func testFirstLoad() {
        
    }
    
    func testFetchNewPage() {
        
    }
    
    func testSearchMovie() {
        
    }
    
}

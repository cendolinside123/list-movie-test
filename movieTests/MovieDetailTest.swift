//
//  MovieDetailTest.swift
//  movieTests
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import XCTest
@testable import movie

class MovieDetailTest: XCTestCase {
    
    class MockupClass: MovieDetailDelegate {
        
        var error: Error?
        var result: (MovieDetailModel, [CastModel])?
        var viewModel = MovieDetailViewModelImpl()
        
        var expectation: XCTestExpectation?
        
        init() {
            viewModel.delegate = self
        }
        
        func onSuccess() {
            self.result = viewModel.movieInformation
            expectation?.fulfill()
        }
        
        func onError(error: Error) {
            self.error = error
            expectation?.fulfill()
        }
        
        func onLoading() {
            
        }
        
        func onEndLoading() {
            
        }
        
        
    }
    
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
    
    func testLoadDetailmovie() {
        let expectation = XCTestExpectation(description: "Delegate receives events")
        expectation.expectedFulfillmentCount = 1
        
        let mockClass = MockupClass()
        mockClass.expectation = expectation
        
        mockClass.viewModel.loadMovieDetail(movieID: 7451)
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        
        if result == XCTWaiter.Result.completed {
            XCTAssertNil(mockClass.error, "error not happened")
            XCTAssertNotNil(mockClass.result, "value movie detail not null")
            XCTAssert((mockClass.result?.1.count ?? 0) > 0, "list cast must bigger thn zero")
        } else {
            XCTAssert(false, "req timeout")
        }
    }
    
    
}

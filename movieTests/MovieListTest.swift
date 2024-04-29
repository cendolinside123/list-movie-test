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
    
    class MockupClass: MovieListDelegate {
        
        var error: Error?
        var listDatalog: [[movie.MovieModel]?] = []
        var viewModel = MovieListViewModelImpl()
        
        var expectation: XCTestExpectation?
        
        init() {
            self.viewModel.delegate = self
        }
        
        func onSuccess() {
            listDatalog.append(viewModel.listMovie)
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
    
    func testFirstLoad() {
        let expectation = XCTestExpectation(description: "Delegate receives events")
        expectation.expectedFulfillmentCount = 1
        
        let mockClass = MockupClass()
        mockClass.expectation = expectation
        
        mockClass.viewModel.firstInitials()
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        
        if result == XCTWaiter.Result.completed {
            XCTAssert(mockClass.listDatalog.count == 1, "Delegate should receive one events")
            XCTAssertNotNil(mockClass.listDatalog[0], "value should not nil")
            XCTAssert((mockClass.listDatalog[0]?.count ?? 0) > 0, "value should bigger than zero")
        } else {
            XCTAssert(false, "req timeout")
        }
    }
    
    func testFetchNewPage() {
        let expectation = XCTestExpectation(description: "Delegate receives events")
        expectation.expectedFulfillmentCount = 1
        
        let mockClass = MockupClass()
        mockClass.expectation = expectation
        
        mockClass.viewModel.firstInitials()
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        
        if result == XCTWaiter.Result.completed {
            XCTAssert(mockClass.listDatalog.count == 1, "Delegate should receive one events")
            XCTAssertNotNil(mockClass.listDatalog[0], "value should not nil")
            XCTAssert((mockClass.listDatalog[0]?.count ?? 0) > 0, "value should bigger than zero")
            
            let secondExpectation = XCTestExpectation(description: "Delegate receives new events")
            mockClass.expectation = secondExpectation
            mockClass.viewModel.fetchMovie(isReFetch: false)
            let resultSecond = XCTWaiter.wait(for: [secondExpectation], timeout: 5)
            if resultSecond == XCTWaiter.Result.completed {
                XCTAssert(mockClass.listDatalog.count == 2, "Delegate should receive three events")
                XCTAssertNotNil(mockClass.listDatalog[0], "value should not nil")
                XCTAssert((mockClass.listDatalog[0]?.count ?? 0) > 0, "value should bigger than zero")
                XCTAssertNotNil(mockClass.listDatalog[1], "value should not nil")
                XCTAssert((mockClass.listDatalog[1]?.count ?? 0) > 0, "value should bigger than zero")
            } else {
                XCTAssert(false, "req timeout")
            }
        } else {
            XCTAssert(false, "req timeout")
        }
    }
    
    func testSearchMovie() {
        let expectation = XCTestExpectation(description: "Delegate receives events")
        expectation.expectedFulfillmentCount = 1
        
        let mockClass = MockupClass()
        mockClass.expectation = expectation
        
        mockClass.viewModel.firstInitials()
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        
        if result == XCTWaiter.Result.completed {
            XCTAssert(mockClass.listDatalog.count == 1, "Delegate should receive one events")
            XCTAssertNotNil(mockClass.listDatalog[0], "value should not nil")
            XCTAssert((mockClass.listDatalog[0]?.count ?? 0) > 0, "value should bigger than zero")
            
            let secondExpectation = XCTestExpectation(description: "Delegate receives new events")
            mockClass.expectation = secondExpectation
            mockClass.viewModel.fetchMovie(keyWord: "run", isRefetch: false)
            let resultSecond = XCTWaiter.wait(for: [secondExpectation], timeout: 5)
            if resultSecond == XCTWaiter.Result.completed {
                XCTAssert(mockClass.listDatalog.count == 2, "Delegate should receive three events")
                XCTAssertNotNil(mockClass.listDatalog[0], "value should not nil")
                XCTAssert((mockClass.listDatalog[0]?.count ?? 0) > 0, "value should bigger than zero")
                XCTAssertNotNil(mockClass.listDatalog[1], "value should not nil")
                XCTAssert((mockClass.listDatalog[1]?.count ?? 0) > 0, "value should bigger than zero")
            } else {
                XCTAssert(false, "req timeout")
            }
        } else {
            XCTAssert(false, "req timeout")
        }
    }
    
}

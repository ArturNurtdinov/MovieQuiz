//
//  MoviesLoaderTests.swift
//  MovieQuiz
//
//  Created by arnurtdinov on 08.02.2026.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        let moviesLoader = MoviesLoader(networkClient: StubNetworkClient())
        
        let expectation = expectation(description: "Loading expectation")
        
        moviesLoader.loadMovies { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        let moviesLoader = MoviesLoader(networkClient: StubNetworkClient(emulateError: true))
        
        let expectation = expectation(description: "Failure expectation")
        
        moviesLoader.loadMovies { result in
            switch result {
            case .success(let movies):
                XCTFail("Unexpected successful loading")
            case.failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}

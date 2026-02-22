//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by arnurtdinov on 25.01.2026.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {

    func testGetValueInRange() throws {
        let array = [1, 2, 3]
        let index = 2
        
        let value = array[safe: index]
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1, 2, 3]
        let index = 4
        
        let value = array[safe: index]
        XCTAssertNil(value)
    }

}

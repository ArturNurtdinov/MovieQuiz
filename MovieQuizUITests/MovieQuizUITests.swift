//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by arnurtdinov on 08.02.2026.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }

    func testScreenCast() throws {
        let posterIdentifier = "Poster"
        let buttonText = "Нет"
        let firstPoster = app.icons[posterIdentifier]
        app.buttons[buttonText].tap()
        let secondPoster = app.icons[posterIdentifier]
        XCTAssertNotEqual(firstPoster, secondPoster)
    }
}

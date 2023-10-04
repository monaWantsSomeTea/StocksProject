//
//  StocksProjectTests.swift
//  StocksProjectTests
//
//  Created by Mona Zheng on 9/27/23.
//

import XCTest
@testable import StocksProject

final class StocksProjectTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMemoryLeak_forStocksListViewController() {
        let sut = StocksListViewController()
        // ErrorView initializes with self for `StocksListViewController`
        let _ = sut.errorView
        
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Potential memory leak, this object should have been deallocated")
        }
    }
    
    func testMemoryLeak_forErrorView() {
        let sut: StocksListViewController? = StocksListViewController()
        let view = sut?.errorView
        // Pressed retry button calls the method from StocksListViewController
        view?.pressedRetryButton()
        
        addTeardownBlock { [weak view] in
            XCTAssertNil(view, "Potential memory leak, this object should have been deallocated")
        }
    }
}

// SnapTests.swift
//
// Created by TeChris on 08.03.21.

import XCTest
@testable import Snap

class SnapTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
	
	func testSearchPerformance() throws {
		// This is an example of a performance test case.
		measure {
			// Measure the time of Searching for a String in Spotlight.
			let search = Search()
			search.startSearchForString("st")
			
			// Wait until the Metadata Query has finished gathering.
			expectation(forNotification: .NSMetadataQueryDidFinishGathering, object: nil, handler: nil)
			waitForExpectations(timeout: 10, handler: nil)
			
			print(search.results)
		}
	}

    func testPerformanceExample() throws {
       
    }

}

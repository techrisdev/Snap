// SnapTests.swift
//
// Created by TeChris on 08.03.21.

import XCTest
@testable import Snap

class SnapTests: XCTestCase {
	func testSearchPerformance() throws {
		measure {
			// Measure the time of Searching for a String in Spotlight.
			let search = Search()
			search.searchForString("test")
			
			// Wait until the Metadata Query has finished gathering.
			expectation(forNotification: .NSMetadataQueryDidFinishGathering, object: nil, handler: nil)
			waitForExpectations(timeout: 10, handler: nil)
			
			print(search.results)
		}
	}
}

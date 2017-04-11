//
//  GCDTests.swift
//  Swiften
//
//  Created by Cator Vee on 10/03/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import XCTest
import Swiften

class GCDTests: XCTestCase {
	
	func testDelaySeconds() {
		let exp = expectation(description: "")
		
		let startTime = Date()
		delay(seconds: 1) {
			let endTime = Date()
			let timeInterval = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
			XCTAssertGreaterThanOrEqual(timeInterval, 1)
			XCTAssertLessThan(timeInterval, 1.1)
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testDelayMilliseconds() {
		let exp = expectation(description: "")
		
		let startTime = Date()
		delay(milliseconds: 100) {
			let endTime = Date()
			let timeInterval = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
			XCTAssertGreaterThanOrEqual(timeInterval, 0.1)
			XCTAssertLessThan(timeInterval, 0.2)
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testAsyncBackgroundAndMain() {
		let exp = expectation(description: "")
		
		let value = 10
		async(background: {
			return value + 1
		}, main: { value in
			XCTAssertEqual(value, 11)
			exp.fulfill()
		})
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testAsyncMain() {
		let exp = expectation(description: "")
		
		var value = 10
		async {
			XCTAssertEqual(value, 11)
			exp.fulfill()
		}
		value += 1
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
}

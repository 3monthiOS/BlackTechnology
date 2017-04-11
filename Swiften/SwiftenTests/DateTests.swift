//
//  DateTests.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest

class DateTests: XCTestCase {
  
  let dateString = "2016-06-08 11:22:33"
  let dateFormat = "yyyy-MM-dd HH:mm:ss"
  
  func testComponents() {
    if let date = Date(string: dateString, format: dateFormat) {
      let components = date.components()
      XCTAssertEqual(components.year, 2016)
      XCTAssertEqual(components.month, 6)
      XCTAssertEqual(components.day, 8)
      XCTAssertEqual(components.hour, 11)
      XCTAssertEqual(components.minute, 22)
      XCTAssertEqual(components.second, 33)
      XCTAssertEqual(components.weekday, 4)
      
      let day = date.components([.day]).day
      XCTAssertEqual(day, 8)
      
      let hour = date.component(.hour)
      XCTAssertEqual(hour, 11)
    }
  }
  
  func testString() {
    if let date = Date(string: dateString, format: dateFormat) {
      XCTAssertEqual(String(date, format: dateFormat), dateString)
      XCTAssertEqual(String(date), dateString)
    }
  }
  
  func testTimestamp() {
    if let date = Date(string: dateString, format: dateFormat) {
      XCTAssertEqual(date.unixTimestamp, 1465356153)
      XCTAssertEqual(date.timestamp, 1465356153000)
    }
  }
  
}

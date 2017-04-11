//
//  LogTests.swift
//  Swiften
//
//  Created by Cator Vee on 5/25/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest
@testable import Swiften

class LogTests: XCTestCase {
  
  func testLevel() {
    XCTAssertLessThan(Log.LEVEL_NONE, Log.LEVEL_ERROR)
    XCTAssertLessThan(Log.LEVEL_ERROR, Log.LEVEL_WARN)
    XCTAssertLessThan(Log.LEVEL_WARN, Log.LEVEL_INFO)
    XCTAssertLessThan(Log.LEVEL_INFO, Log.LEVEL_DEBUG)
    
    Log.debug("xxxxxx")
  }
  
}

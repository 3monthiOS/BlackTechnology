//
//  AppTests.swift
//  Swiften
//
//  Created by Cator Vee on 18/02/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import XCTest
import Swiften

class AppTests: XCTestCase {
  
  func testAppBundle() {
    let bundle = App.bundle
    XCTAssert(bundle === Bundle.main)
  }
  
  func testAppLang() {
    let lang = App.lang
    XCTAssert(lang == "en")
  }
  
}

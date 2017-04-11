//
//  UDIDTests.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest
import Swiften

class UDIDTests: XCTestCase {
  
  func testUDID() {
    let udid1 = UDID().udidString
    let udid2 = UDID().udidString
    
    XCTAssertEqual(udid1.length, 32)
    XCTAssertEqual(udid1, udid2)
  }
  
}

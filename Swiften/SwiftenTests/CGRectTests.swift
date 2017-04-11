//
//  CGRectTests.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest

class CGRectTests: XCTestCase {
  
  func testCenter() {
    let rect = CGRect(x: 100, y: 100, width: 200, height: 200)
    let point = CGPoint(x: 200, y: 200)
    XCTAssertEqual(rect.center, point)
    
    var rect2 = rect
    let point2 = CGPoint(x: 500, y: 500)
    rect2.center = point2
    XCTAssertEqual(rect2.center, point2)
  }
  
}

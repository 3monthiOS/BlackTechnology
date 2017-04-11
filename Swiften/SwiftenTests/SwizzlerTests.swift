//
//  SwizzlerTests.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest
@testable import Swiften

class TestSwizzling: NSObject {
  dynamic func methodOne() -> Int {
    return 1
  }
}

extension TestSwizzling {  
  func methodTwo() -> Int {
    return methodTwo() + 1
  }
}

class SwizzlerTests: XCTestCase {
  
  func testSwizzle() {
		Swizzler.swizzleMethod(#selector(TestSwizzling.methodOne), with: #selector(TestSwizzling.methodTwo), forClass: TestSwizzling.self)
    let c = TestSwizzling()
    XCTAssertEqual(c.methodOne(), 2)
    XCTAssertEqual(c.methodTwo(), 1)
  }
  
}

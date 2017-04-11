//
//  UIViewTests.swift
//  Swiften
//
//  Created by Cator Vee on 5/27/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest
import Swiften

class CustomView: UIView {
  override func setupView() {
    self.tag = 100
    Log.debug("#########################")
  }
}

//extension UIView {
//    override public class func initialize() {
//        super.initialize()
//        Log.debug("================================")
//        swizzles_swiften()
//    }
//}

class UIViewTests: XCTestCase {
  
  override func setUp() {
    Swiften.initFramework()
    Swiften.initFramework()
  }
  
  func testPerformanceExample() {
    let view = CustomView()
    XCTAssertEqual(view.tag, 100)
  }
  
}

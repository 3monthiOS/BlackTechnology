//
//  UIColorTests.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest

class UIColorTests: XCTestCase {
  
  func testRGBA() {
    let colorA = UIColor(red: 0x10 / 255, green: 0x20 / 255, blue: 0x30 / 255, alpha: 0x99 / 255)
    let colorB = UIColor(red: 0x10 / 255, green: 0x20 / 255, blue: 0x30 / 255, alpha: 1)
    
    let color1 = UIColor(r: 0x10, g: 0x20, b: 0x30, alpha: 0x99 / 255)
    let color2 = UIColor(rgb: 0x102030)
    let color3 = UIColor(rgba: 0x10203099)
    
    XCTAssertEqual(color1, colorA)
    XCTAssertEqual(color2, colorB)
    XCTAssertEqual(color3, colorA)
  }
  
}

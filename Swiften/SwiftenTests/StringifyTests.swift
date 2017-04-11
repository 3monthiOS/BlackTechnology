//
//  StringifyTests.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest
@testable import Swiften
import SwiftyJSON

class StringifyTests: XCTestCase {
  
  func testJSON() {
    let str = "{\"key\":\"value中文emoji😃\"}"
    let json: JSON = ["key": "value中文emoji😃"]
    XCTAssertEqual(str, json.jsonString)
    XCTAssertEqual(json, str.json)
  }
  
  func testData() {
    let str1 = "123中文"
    let data1 = str1.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    XCTAssertEqual(str1.data, data1)
    XCTAssertEqual(str1, data1.string)
  }
  
  func testInt() {
    let str1 = "123"
    let str2 = "123a"
    let str3 = "a123"
    
    let int0: Int = 0
    let int123: Int = 123
    
    XCTAssertEqual(str1.intValue, int123)
    XCTAssertEqual(str2.intValue, int123)
    XCTAssertEqual(str3.intValue, int0)
    
    XCTAssertEqual(str1.int32Value, Int32(int123))
    XCTAssertEqual(str2.int32Value, Int32(int123))
    XCTAssertEqual(str3.int32Value, Int32(int0))
    
    XCTAssertEqual(str1.int64Value, Int64(int123))
    XCTAssertEqual(str2.int64Value, Int64(int123))
    XCTAssertEqual(str3.int64Value, Int64(int0))
  }
  
  func testFloat() {
    let str1 = "123.45"
    let str2 = "123.45a"
    let str3 = "a123.45"
    
    let float0: Float = 0
    let float123: Float = 123.45
    
    XCTAssertEqual(str1.floatValue, float123)
    XCTAssertEqual(str2.floatValue, float123)
    XCTAssertEqual(str3.floatValue, float0)
  }
  
  func testDouble() {
    let str1 = "123.45"
    let str2 = "123.45a"
    let str3 = "a123.45"
    
    let double0: Double = 0
    let double123: Double = 123.45
    
    XCTAssertEqual(str1.doubleValue, double123)
    XCTAssertEqual(str2.doubleValue, double123)
    XCTAssertEqual(str3.doubleValue, double0)
  }
  
  func testBool() {
    for str in ["true", "True", "yes", "YES", "1", "2", "3", "4", "5", "6", "7", "8", "ttt"] {
      XCTAssertTrue(str.boolValue)
    }
    for str in ["false", "falsebb", "false", "False", "FalSe", "FALSE", "No", "no", "NO", "OFF", "OFF2"] {
      XCTAssertFalse(str.boolValue)
    }
  }
}

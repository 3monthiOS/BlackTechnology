//
//  DataTests.swift
//  Swiften
//
//  Created by Cator Vee on 22/02/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import XCTest

class DataTests: XCTestCase {
  
  func testHexString() {
    let data1 = "cator".data(using: .utf8)!.md5
    let data2 = Data(hexString: data1.hexString)
    XCTAssertNotNil(data2)
    XCTAssertEqual(data1, data2)
    
    let data3 = Data(hexString: "4a4b4c4D4e4F51525354555657585950e9ad8fE6b0B8E5A29e")
    let data4 = "JKLMNOQRSTUVWXYP魏永增".data(using: .utf8)
    XCTAssertNotNil(data3)
    XCTAssertEqual(data3, data4)
  }
  
}

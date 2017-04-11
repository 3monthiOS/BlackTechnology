//
//  ContentTypeTests.swift
//  Swiften
//
//  Created by Cator Vee on 24/02/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import XCTest
import Swiften

class ContentTypeTests: XCTestCase {
    
    func test() {
      let contentType = ContentType("text/html; charset = UTF-8")
      XCTAssertEqual(contentType.description, "text/html; charset=utf-8")
      
      let contentType2 = ContentType(type: "text", subtype: "html", charset: "utf-8")
      XCTAssertEqual(contentType2.description, "text/html; charset=utf-8")
      
      XCTAssertTrue(contentType == contentType2)
      
      let contentType3 = contentType2.with(charset: "gbk")
      XCTAssertEqual(contentType3.description, "text/html; charset=gbk")
      
      let ct4: ContentType = .json
      XCTAssertEqual(ct4.description, "application/json")
      XCTAssertEqual(ct4.suffix, ".json")
      
      XCTAssertTrue(ct4.isCompatible(with: ContentType("application/*")))
    }
    
}

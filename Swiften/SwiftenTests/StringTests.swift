//
//  StringTests.swift
//  Swiften
//
//  Created by Cator Vee on 5/23/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest

class StringTests: XCTestCase {
  
  func testLength() {
    let str1 = "1234567890"
    XCTAssertEqual(str1.length, 10)
    
    let str2 = "123中文"
    XCTAssertEqual(str2.length, 5)
    
    let str3 = "emoji😃"
    XCTAssertEqual(str3.length, 6)
  }
  
  func testUrlEncode() {
    let str1 = "http://www.hostname.com/path/to/file.html?q1=a&a1=b#hash"
    let str2 = str1.urlEncoded
    XCTAssertEqual(str2, "http%3A%2F%2Fwww.hostname.com%2Fpath%2Fto%2Ffile.html%3Fq1%3Da%26a1%3Db%23hash")
    XCTAssertEqual(str2.urlDecoded, str1)
  }
  
  func testDigest() {
    let str = "cator"
    XCTAssertEqual(str.md5, "671711a7ce87226106994d106158b31c")
    XCTAssertEqual(str.sha1, "7834b483cfe6bfd8373fa3ff1aa2aeb10d233a18")
  }
  
  func testBase64() {
    let str = "cator"
    let encoded = str.base64Encoded
    XCTAssertEqual(encoded, "Y2F0b3I=")
    XCTAssertEqual(encoded.base64Decoded, str)
  }
  
  func testSize() {
    let str = "cator"
    let fontSize: CGFloat = 16
    let font = UIFont.systemFont(ofSize: 16)
    
    let size1 = str.size(fontSize: fontSize)
    let size2 = str.size(font: font)
    let size3 = str.size(fontSize: fontSize, width: 32)
    let size4 = str.size(font: font, width: 32)
    
    XCTAssertEqual(size1, CGSize(width: 37.4609375, height: 19.09375))
    XCTAssertEqual(size2, CGSize(width: 37.4609375, height: 19.09375))
    XCTAssertEqual(size3, CGSize(width: 31.6796875, height: 38.1875))
    XCTAssertEqual(size4, CGSize(width: 31.6796875, height: 38.1875))
  }
  
  func testSubstring() {
    let str = "cator魏永增emoji😃"
    
    XCTAssertEqual(str.substring(3), "or魏永增emoji😃")
    XCTAssertEqual(str.substring(-3), "ji😃")
    XCTAssertEqual(str.substring(3, -3), "or魏永增emo")
    XCTAssertEqual(str.substring(0, 100), str)
    XCTAssertNil(str.substring(9, 1))
    XCTAssertNil(str.substring(100, str.length))
    XCTAssertNil(str.substring(0, -100))
    
    XCTAssertEqual(str[0...0], "c")
    XCTAssertEqual(str[3..<7], "or魏永")
    XCTAssertEqual(str[3...7], "or魏永增")
    
    XCTAssertEqual(str[6], "永")
    XCTAssertNil(str[100])
    XCTAssertNil(str[-1])
    
    var str2 = str
    str2[0] = "😊"
    XCTAssertEqual(str2, "😊ator魏永增emoji😃")
    str2[5] = "😊"
    XCTAssertEqual(str2, "😊ator😊永增emoji😃")
    str2[5] = nil
    XCTAssertEqual(str2, "😊ator永增emoji😃")
    
    var str3 = str
    str3[0..<5] = "😊"
    XCTAssertEqual(str3, "😊魏永增emoji😃")
    str3[1..<4] = "😊"
    XCTAssertEqual(str3, "😊😊emoji😃")
    str3[2..<5] = ""
    XCTAssertEqual(str3, "😊😊ji😃")
    str3[2..<4] = nil
    XCTAssertEqual(str3, "😊😊😃")
    
    var str4 = str
    str4[0...4] = "😊"
    XCTAssertEqual(str4, "😊魏永增emoji😃")
    str4[1...3] = "😊"
    XCTAssertEqual(str4, "😊😊emoji😃")
    str4[2...4] = ""
    XCTAssertEqual(str4, "😊😊ji😃")
    str4[2...3] = nil
    XCTAssertEqual(str4, "😊😊😃")
  }
  
  func testTrim() {
    let str = " \t \n \r cator \r\n\t"
    XCTAssertEqual(str.trimmed, "cator")
  }
}

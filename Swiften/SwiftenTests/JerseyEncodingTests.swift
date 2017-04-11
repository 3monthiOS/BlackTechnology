//
//  JerseyEncodingTests.swift
//  Swiften
//
//  Created by Cator Vee on 09/03/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import XCTest
import Swiften

class JerseyEncodingTests: XCTestCase {
	
	func testNormal() {
		let encoding = JerseyEncoding.default
		let request = URLRequest(url: URL(string: "http://127.0.0.1/")!)
		let encodedRequest = try! encoding.encode(request, with: [
			"v1": 1,
			"v2": true,
			"v3": "string",
			"v4=": "skd-----:#[]@!$&'()*+,;=",
			"v5": 1000000002.423421
			])
		let url = encodedRequest.url!.absoluteString
		XCTAssertEqual(url, "http://127.0.0.1/?v1=1&v2=true&v3=string&v4%3D=skd-----%3A%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D&v5=1000000002.423421")
	}
	
	func testArray() {
		let encoding = JerseyEncoding.default
		let request = URLRequest(url: URL(string: "http://127.0.0.1/")!)
		let encodedRequest = try! encoding.encode(request, with: [
			"v1": [1,2,3,4,6],
			"v2": [true, false, true],
			"v3": [],
			"v4": [["a":1,"b":2], ["c":3,"d":true]]
			])
		let url = encodedRequest.url!.absoluteString
		XCTAssertEqual(url, "http://127.0.0.1/?v1=1&v1=2&v1=3&v1=4&v1=6&v2=true&v2=false&v2=true&v4=%7B%22b%22%3A2%2C%22a%22%3A1%7D&v4=%7B%22d%22%3Atrue%2C%22c%22%3A3%7D")
	}
	
	func testDictionary() {
		let encoding = JerseyEncoding.default
		let request = URLRequest(url: URL(string: "http://127.0.0.1/")!)
		let encodedRequest = try! encoding.encode(request, with: [
			"v4": ["a":[1,2,3,4,6],"b":[true, false, true], "c":3,"d":true]
			])
		let url = encodedRequest.url!.absoluteString
		print(url)
		XCTAssertEqual(url, "http://127.0.0.1/?v4=%7B%22b%22%3A%5Btrue%2Cfalse%2Ctrue%5D%2C%22a%22%3A%5B1%2C2%2C3%2C4%2C6%5D%2C%22d%22%3Atrue%2C%22c%22%3A3%7D")
	}
	
}

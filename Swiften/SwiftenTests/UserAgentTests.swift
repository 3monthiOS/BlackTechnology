//
//  UserAgentTests.swift
//  Swiften
//
//  Created by Cator Vee on 11/03/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import XCTest
import Swiften

class UserAgentTests: XCTestCase {
    
    func test() {
			let userAgent = UserAgent.string
			print(userAgent)
			XCTAssertTrue(userAgent.contains(" \(App.name)/"))
			XCTAssertTrue(userAgent.contains(" NetType/"))
			XCTAssertTrue(userAgent.contains(" Language/\(App.lang)"))
    }
    
}

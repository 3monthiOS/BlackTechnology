//
//  ReachabilityTests.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest
import Swiften
import ReachabilitySwift

class ReachabilityTests: XCTestCase {
  
  func testReachable() {
    guard let reachability = Reachability() else {
      XCTAssertTrue(false)
      return
    }
    
    XCTAssertEqual(reachability.currentReachabilityStatus, Reachability.NetworkStatus.reachableViaWiFi)
    
    XCTAssertTrue(reachability.isReachable)
    XCTAssertTrue(reachability.isReachableViaWiFi)
    XCTAssertFalse(reachability.isReachableViaWWAN)
  }
  
}

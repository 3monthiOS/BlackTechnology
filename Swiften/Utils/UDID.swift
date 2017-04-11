//
//  UDID.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import KeychainSwift

public struct UDID {
  
  public init() {
    // nothing
  }
  
  /// UDID String
  public var udidString: String {
    let keychain = KeychainSwift()
    if let udid = keychain.get("COMMON_UDID") {
      return udid
    }
    
    let udid: String
    if let identifierForVendor = UIDevice.current.identifierForVendor {
      udid = identifierForVendor.uuidString.replacingOccurrences(of: "-", with: "")
    } else {
      udid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
    keychain.set(udid, forKey: "COMMON_UDID")
    return udid
  }
  
}

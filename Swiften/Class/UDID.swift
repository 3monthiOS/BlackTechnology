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
    /// UUID String
    public static var UUIDString: String {
        return UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
    
    /// UDID String
    public static var UDIDString: String {
        let keychain = KeychainSwift()
        if let udid = keychain.get("COMMON_UDID") {
            return udid
        }
        
        let udid = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "")
        keychain.set(udid, forKey: "COMMON_UDID")
        return udid
    }
}

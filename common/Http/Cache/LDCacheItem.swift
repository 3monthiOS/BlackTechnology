//
//  LDCacheItem.swift
//  grapefruit
//
//  Created by Cator Vee on 3/11/16.
//  Copyright © 2016 Ledong. All rights reserved.
//

import Foundation
import Realm
import Realm.Private
import RealmSwift

class LDCacheItem: Object {
    
    // Specify properties to ignore (Realm won't persist these)
    
    dynamic var key: String?
    dynamic var value: String?
    dynamic var expires: Double = 0.0
    
    var isValid: Bool {
        return self.expires > NSDate().timeIntervalSince1970
    }
    
    // 主键
    override static func primaryKey() -> String? {
        return "key"
    }
    
}
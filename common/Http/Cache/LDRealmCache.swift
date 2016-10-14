//
//  LDRealmCache.swift
//  grapefruit
//
//  Created by Cator Vee on 3/11/16.
//  Copyright © 2016 Ledong. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import Swiften

class LDRealmCache: LDCachable {
    
    let realm: Realm
    
    // MARK: - init
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    // MARK: - LDCachable
    
    func get(key: String) -> LDCacheItem? {
        if let item = realm.objectForPrimaryKey(LDCacheItem.self, key: key) where item.isValid {
            return item
        }
        return nil
    }
    
    func set(value: LDCacheItem) {
        try! realm.write {
            realm.add(value, update: true)
        }
    }
    
    func getValue(key: String) -> String? {
        return self.get(key)?.value
    }
    
    func setValue(value: String, forKey key: String, expires: Double?) {
        let item = LDCacheItem()
        item.key = key
        item.value = value
        item.expires = expires ?? NSDate.distantFuture().timeIntervalSince1970
        self.set(item)
    }
    
    func remove(key: String) {
        guard let item = self.get(key) else {return}
        try! realm.write {
            realm.delete(item)
            Log.info("LDRealmCache: remove cache \"\(key)\"")
        }
    }
    
    func clear() {
        do {
            if !realm.isEmpty {
                try realm.write {
                    realm.delete(realm.objects(LDCacheItem.self))
                }
            }
            
            Log.info("LDRealmCache: clear")
        } catch let error as NSError  {
            Log.error("LDRealmCache: clear. \(error)")
        }
    }
}
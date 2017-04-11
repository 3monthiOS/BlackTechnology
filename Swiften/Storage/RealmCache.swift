//
//  RealmCache.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import RealmSwift

open class RealmCacheValue: Object, CacheValue {
  dynamic public var key: String = ""
  dynamic public var value: String = ""
  dynamic public var expires: TimeInterval = 0.0
  
  // 主键
  override open static func primaryKey() -> String? {
    return "key"
  }
  
  public static let om = RealmObjectManager<RealmCacheValue>(realm: Realm.sharedRealm)
  
  public var isValid: Bool {
    return expires < 0.000001 || expires > Date.timeIntervalSinceReferenceDate
  }
}

open class RealmCache: Cachable {
  
  public typealias Value = RealmCacheValue
  
  public init() {
    
  }

  public func value(forKey key: String) -> RealmCacheValue? {
    guard let cacheValue = RealmCacheValue.om.object(primaryKey: key as AnyObject), cacheValue.isValid else {
      return nil
    }
    return cacheValue
  }
  
  public func set(value: RealmCacheValue) {
    RealmCacheValue.om.save(value)
  }
  
  public func string(forKey key: String) -> String? {
    return value(forKey: key)?.value
  }
  
  public func set(string value: String, forKey key: String, expires: TimeInterval) {
    if !key.isEmpty {
      let cacheValue = RealmCacheValue()
      cacheValue.key = key
      cacheValue.value = value
      cacheValue.expires = expires
      set(value: cacheValue)
    }
  }
  
  public func remove(forKey key: String) {
    guard let item = value(forKey: key) else {
      return
    }
    RealmCacheValue.om.delete(item)
  }
  
  public func clear() {
    RealmCacheValue.om.deleteAll()
  }
  
}

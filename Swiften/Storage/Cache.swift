//
//  Cache.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import Realm
import Realm.Private
import RealmSwift
import ObjectMapper

// MARK: - Cachable

public protocol Cachable {
    func value(forKey key: String) -> CacheItem?
    func setValue(_ value: CacheItem)

    func string(forKey key: String) -> String?
    func setString(_ value: String, forKey key: String, expires: Double?)

    func remove(forKey key: String)
    func clear()
}

// MARK: - CacheItem

open class CacheItem: Object {
    dynamic var key: String?
    dynamic var value: String?
    dynamic var expires: Double = 0.0

    // 主键
    override open static func primaryKey() -> String? {
        return "key"
    }

    var isValid: Bool {
        return self.expires > Date.timeIntervalSinceReferenceDate
    }
}

extension CacheItem {
    public static let em = RealmEntityManager<CacheItem>(realm: Realm.sharedRealm)
}

// MARK: - CacheManager

class CacheManager {

    let cachable: Cachable

    init(cachable: Cachable) {
        self.cachable = cachable
    }

    // MARK: - Methods
    
    func object<T: Mappable>(forKey key: String) -> T? {
        guard let content: String = cachable.string(forKey: key) else { return nil }
        return Mapper<T>().map(JSONString: content)
    }

    func setObject<T: Mappable>(_ object: T, forKey key: String, expires: Double? = nil) {
        guard let jsonString = Mapper<T>().toJSONString(object) else { return }
        cachable.setString(jsonString, forKey: key, expires: expires)
    }
    
    func remove(forKey key: String) {
        cachable.remove(forKey: key)
    }

    // MARK: - Subscript

    subscript(key: String) -> CacheItem? {
        get {
            return cachable.value(forKey: key)
        }
        set {
            if let value = newValue {
                value.key = key
                cachable.setValue(value)
            }
        }
    }

    subscript(key: String) -> String? {
        get {
            return cachable.string(forKey: key)
        }
        set {
            if let string = newValue {
                cachable.setString(string, forKey: key, expires: nil)
            }
        }
    }

    subscript(key: String) -> Int? {
        get {
            return cachable.string(forKey: key)?.integer
        }
        set {
            if let string = newValue?.string {
                cachable.setString(string, forKey: key, expires: nil)
            }
        }
    }
    
    subscript(key: String) -> Float? {
        get {
            return cachable.string(forKey: key)?.float
        }
        set {
            if let string = newValue?.string {
                cachable.setString(string, forKey: key, expires: nil)
            }
        }
    }
    
    subscript(key: String) -> Double? {
        get {
            return cachable.string(forKey: key)?.double
        }
        set {
            if let string = newValue?.string {
                cachable.setString(string, forKey: key, expires: nil)
            }
        }
    }
    
    subscript(key: String) -> Bool? {
        get {
            return cachable.string(forKey: key)?.bool
        }
        set {
            if let string = newValue?.string {
                cachable.setString(string, forKey: key, expires: nil)
            }
        }
    }
    
}

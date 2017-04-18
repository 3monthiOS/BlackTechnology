//
//  LDCacheSettings.swift
//  grapefruit
//
//  Created by Cator Vee on 3/11/16.
//  Copyright © 2016 Ledong. All rights reserved.
//

import Foundation
import ObjectMapper
//import Swiften

class LDCacheSettings {
    
    enum Key: String {
        case Location = "_Location"
        case User = "_User"
        case Agent = "_Agent"
        case LastAppVersion = "_LastAppVersion"
        case RongCloudToken = "_RongCloudToken"
        case GetGraphicPushTime = "_GetGraphicPushTime"
        
        func suffixWith(_ suffix: AnyObject) -> String {
            return "\(self.rawValue)_\(suffix)"
        }
        
    }
    
    let manager: LDCachable
    
    init(manager: LDCachable) {
        self.manager = manager
    }
    
    // MARK: - Methods
    
    func setValue(_ value: String, forKey key: String, expires: Double) {
        self.manager.setValue(value, forKey: key, expires: expires)
    }
    
    func setValue(_ value: String, forKey key: Key, expires: Double) {
        self.setValue(value, forKey: key.rawValue, expires: expires)
    }
    
    func setObject<T: Mappable>(_ object: T, forKey key: Key, expires: Double? = nil) {
        self.setObject(object, forKey: key.rawValue, expires: expires)
    }
    
    func setObject<T: Mappable>(_ object: T, forKey key: String, expires: Double? = nil) {
        guard let jsonString = Mapper<T>().toJSONString(object) else {return}
        cache[key] = jsonString
    }
    
    func objectForKey<T: Mappable>(_ key: Key) -> T? {
        return self.objectForKey(key.rawValue)
    }
    
    func objectForKey<T: Mappable>(_ key: String) -> T? {
        guard let content: String = cache[key] else {return nil}
        return Mapper<T>().map(content)
    }
    
    func remove(_ key: Key) {
        self.manager.remove(key.rawValue)
    }
    
    /** 根据Key存取 Cache 数据 */
    subscript(key: Key) -> LDCacheItem? {
        get {
            return self.manager.get(key.rawValue)
        }
        set {
            if let value = newValue {
                value.key = key.rawValue
                self.manager.set(value)
            }
        }
    }
    
    /** 支持直接存取 String 类型的数据 */
    subscript(key: Key) -> String? {
        get {
            return self.manager.getValue(key.rawValue)
        }
        set {
            if let value = newValue {
                self.manager.setValue(value, forKey: key.rawValue, expires: nil)
            }
        }
    }
    
    /** 支持根据String类型的key直接存取 String 类型的数据 */
    subscript(key: String) -> String? {
        get {
            return self.manager.getValue(key)
        }
        set {
            if let value = newValue {
                self.manager.setValue(value, forKey:key, expires: nil)
            }
        }
    }
    
    /** 支持直接存取 Int 类型的数据 */
    subscript(key: Key) -> Int? {
        get {
            if let value: String = self.manager.getValue(key.rawValue) {
                return Int(value)
            } else {
                return nil
            }
        }
        set {
            if let value = newValue {
                self.manager.setValue(String(value), forKey: key.rawValue, expires: nil)
            }
        }
    }
    
    /** 支持直接存取 FLoat 类型的数据 */
    subscript(key: Key) -> Float? {
        get {
            if let value: String = self.manager.getValue(key.rawValue) {
                return Float(value)
            } else {
                return nil
            }
        }
        set {
            if let value = newValue {
                self.manager.setValue(String(value), forKey: key.rawValue, expires: nil)
            }
        }
    }
    
    /*支持Double*/
    subscript(key:Key) -> Double? {
        get {
            if let value: String = self.manager.getValue(key.rawValue) {
                return Double(value)
            } else {
                return nil
            }
        }
        set {
            if let value = newValue {
                self.manager.setValue(String(value), forKey: key.rawValue, expires: nil)
            }
        }
    }
}

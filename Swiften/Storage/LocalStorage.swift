//
//  LocalStorage.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

open class LocalStorage {
	private let defaults: UserDefaults
	private var autoCommit: Bool
	
	public init() {
		defaults = UserDefaults.standard
		autoCommit = true
	}
  
  open func set(_ value: Any?, forKey key: String) {
    defaults.set(value, forKey: key)
    if autoCommit {
      defaults.synchronize()
    }
  }
  
  open func object<T>(forKey key: String) -> T? {
    return defaults.object(forKey: key) as? T
  }
  
  open func string(forKey key: String) -> String? {
    return defaults.string(forKey: key)
  }
  
  open func data(forKey key: String) -> Data? {
    return defaults.data(forKey: key)
  }
  
  open func int(forKey key: String) -> Int {
    return defaults.integer(forKey: key)
  }
  
  open func float(forKey key: String) -> Float {
    return defaults.float(forKey: key)
  }
  
  open func double(forKey key: String) -> Double {
    return defaults.double(forKey: key)
  }
  
  open func bool(forKey key: String) -> Bool {
    return defaults.bool(forKey: key)
  }
  
  open func url(forKey key: String) -> URL? {
    return defaults.url(forKey: key)
  }
  
  open func array<T>(forKey key: String) -> [T]? {
    return defaults.array(forKey: key) as? [T]
  }
  
  open func dictionary<T>(forKey key: String) -> [String: T]? {
    return defaults.dictionary(forKey: key) as? [String: T]
  }
  
  open func date(forKey key: String) -> Date? {
    return defaults.object(forKey: key) as? Date
  }
  
  open func removeObject(forKey key: String) {
    defaults.removeObject(forKey: key)
  }
  
  open func reset() {
    UserDefaults.resetStandardUserDefaults()
  }
  
  open func write(callback: () -> Void) {
    autoCommit = false
    callback()
    defaults.synchronize()
    autoCommit = true
  }
  
}

//
//  CacheTests.swift
//  Swiften
//
//  Created by Cator Vee on 19/02/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import XCTest
import Swiften
import ObjectMapper

fileprivate enum Caches: String {
  case test
  
  static let manager = CacheManager(RealmCache())
  
  var string: String? {
    return Caches.manager[rawValue]
  }
  
  var int: Int? {
    return Caches.manager[rawValue]
  }
  
  var double: Double? {
    return Caches.manager[rawValue]
  }
  
  var bool: Bool? {
    return Caches.manager[rawValue]
  }
  
  func set(_ string: String, expires: TimeInterval = 0.0) {
    Caches.manager.cachable.set(string: string, forKey: rawValue, expires: expires)
  }
  
  func set(_ int: Int, expires: TimeInterval = 0.0) {
    Caches.manager.cachable.set(string: String(int), forKey: rawValue, expires: expires)
  }
  
  func set(_ double: Double, expires: TimeInterval = 0.0) {
    Caches.manager.cachable.set(string: String(double), forKey: rawValue, expires: expires)
  }
  
  func set(_ bool: Bool, expires: TimeInterval = 0.0) {
    Caches.manager.cachable.set(string: String(bool), forKey: rawValue, expires: expires)
  }
  
  func get<T: Mappable>() -> T? {
    return Caches.manager.object(forKey: rawValue)
  }
  
  func set<T: Mappable>(_ object: T, expires: Double = 0.0) {
    Caches.manager.set(object: object, forKey: rawValue, expires: expires)
  }
  
  func remove() {
    Caches.manager.remove(forKey: rawValue)
  }
  
}

fileprivate class Model: Mappable {
  var name: String?
  var age: Int = 0
  
  init() {
    // noting
  }
  
  required init?(map: Map) {
    // nothing
  }
  
  func mapping(map: Map) {
    name <- map["name"]
    age <- map["age"]
  }
}

class CacheTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    Caches.manager.clear()
  }
  
  func testString() {
    XCTAssertNil(Caches.test.string)
    
    Caches.test.set("test string")
    XCTAssertEqual(Caches.test.string, "test string")
    
    Caches.test.set(135)
    XCTAssertEqual(Caches.test.int, 135)
    
    Caches.test.set(135.789)
    XCTAssertEqual(Caches.test.double, 135.789)
    
    Caches.test.set(true)
    XCTAssertTrue(Caches.test.bool!)
    
    XCTAssertNotNil(Caches.test.string)
    Caches.test.remove()
    XCTAssertNil(Caches.test.string)
    
    let model = Model()
    model.name = "cator"
    model.age = 18
    Caches.test.set(model)
    XCTAssertEqual(Caches.test.string, "{\"name\":\"cator\",\"age\":18}")
    
    let model2: Model = Caches.test.get()!
    XCTAssertEqual(model2.name, "cator")
    XCTAssertEqual(model2.age, 18)
  }
  
}

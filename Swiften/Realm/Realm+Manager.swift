//
//  Realm+Manager.swift
//  Swiften
//
//  Created by Cator Vee on 5/25/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
  
  public static let defaultRootUrl = Realm.Configuration.defaultConfiguration.fileURL?.deletingLastPathComponent()
  
  public static func createRealm(name: String) -> Realm? {
    guard let url = defaultRootUrl?.appendingPathComponent("\(name).realm") else {
      Log.error("无效的数据库路径： \(name).realm in \(String(describing: defaultRootUrl))")
      return nil
    }
    do {
      return try Realm(fileURL: url)
    } catch let error {
      Log.error("创建数据库失败：\(error)")
    }
    return nil
  }
  
  private static var _userRealm: Realm!
  public static var userRealm: Realm! {
    get {
      return _userRealm ?? sharedRealm
    }
    set {
      _userRealm = newValue
    }
  }
  
  private static var _sharedRealm: Realm!
  public static var sharedRealm: Realm! {
    get {
      if _sharedRealm == nil {
        _sharedRealm = createRealm(name: "shared")
      }
      return _sharedRealm
    }
    set {
      _sharedRealm = newValue
    }
  }
  
}

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
    
//    public static let rootPath = (Realm.Configuration.defaultConfiguration.path! as NSString).stringByDeletingLastPathComponent
     public static let rootPath = (Realm.Configuration.defaultConfiguration.fileURL!.path as NSString).deletingLastPathComponent
    
    fileprivate static var _userRealm: Realm!
    public static var userRealm: Realm {
        if _userRealm == nil {
            //let realm = Realm.sharedRealm()
            //if let user = auth.user {
                //Realm._userRealm = try! Realm(path: "\(Realm.rootPath)/\(user.id).realm")
            //} else {
                //return realm
            //}
            return Realm.sharedRealm
        }
        return _userRealm
    }
    
    public static func setUserRealm(_ realm: Realm) {
        _userRealm = realm
    }
    
    public static func resetUserRealm() {
        _userRealm = nil
    }
    
    fileprivate static var _sharedRealm: Realm!
    public static var sharedRealm: Realm {
        if _sharedRealm == nil {
//            _sharedRealm = try! Realm(path: "\(rootPath)/shared.realm")
            _sharedRealm = try! Realm(fileURL: NSURL(string:"\(rootPath)/shared.realm")! as URL)
        }
        return _sharedRealm
    }
    
    public static func setSharedRealm(_ realm: Realm) {
        _sharedRealm = realm
    }
}

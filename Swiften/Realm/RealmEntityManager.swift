//
//  RealmEntityManager.swift
//  Swiften
//
//  Created by Cator Vee on 5/25/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import RealmSwift

open class RealmEntityManager<T: Object> {

    open var realm: Realm

    public init(realm: Realm) {
        self.realm = realm
    }
    
    // MARK: - Query Entity

    open var objects: Results<T> {
        return realm.objects(T.self)
    }

    open func object(primaryKey key: AnyObject) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }

    open func query(_ predicateFormat: String, _ args: AnyObject...) -> Results<T> {
        return objects.filter(predicateFormat, args)
    }

    open func query(_ predicate: NSPredicate) -> Results<T> {
        return objects.filter(predicate)
    }

    // MARK: - Create Entity

    open func create(_ value: AnyObject) -> T? {
        var entity: T?
        do {
            try realm.write { [weak realm] in
                entity = realm?.create(T.self, value: value, update: true)
            }
        } catch let error {
            Log.error("EntityManager: \(error)")
        }
        return entity
    }

    // MARK: - Save Entity

    open func save(_ object: T) {
        do {
            try realm.write { [weak realm] in
                realm?.add(object, update: true)
            }
        } catch let error {
            Log.error("EntityManager: \(error)")
        }
    }

    open func write(_ callback: () -> Void) {
        do {
            try realm.write(callback)
        } catch let error {
            Log.error("EntityManager: \(error)")
        }
    }

    // MARK: - Delete Entity

    open func delete(_ object: T) {
        do {
            try realm.write { [weak realm] in
                realm?.delete(object)
            }
        } catch let error {
            Log.error("EntityManager: \(error)")
        }
    }

    open func delete(_ objects: Results<T>) {
        do {
            try realm.write { [weak realm] in
                realm?.delete(objects)
            }
        } catch let error {
            Log.error("EntityManager: \(error)")
        }
    }

    open func delete(_ objects: List<T>) {
        do {
            try realm.write { [weak realm] in
                realm?.delete(objects)
            }
        } catch let error {
            Log.error("EntityManager: \(error)")
        }
    }

    open func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        do {
            try realm.write { [weak realm] in
                realm?.delete(objects)
            }
        } catch let error {
            Log.error("EntityManager: \(error)")
        }
    }

    open func delete(_ predicateFormat: String, _ args: AnyObject...) {
        delete(objects.filter(predicateFormat, args))
    }

    open func delete(_ predicate: NSPredicate) {
        delete(objects.filter(predicate))
    }

    open func delete(primaryKey key: AnyObject) {
        if let object = object(primaryKey: key) {
            delete(object)
        }
    }

    open func deleteAll() {
        do {
            try realm.write { [objects, weak realm] in
                realm?.delete(objects)
            }
        } catch let error as NSError {
            Log.error("EntityManager: \(error)")
        }
    }

}

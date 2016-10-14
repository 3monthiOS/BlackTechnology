//
//  LDCachable.swift
//  grapefruit
//
//  Created by Cator Vee on 3/11/16.
//  Copyright © 2016 Ledong. All rights reserved.
//

import Foundation

// MARK: - LDCache

protocol LDCachable {
    
    func get(key: String) -> LDCacheItem?
    func set(value: LDCacheItem)
    
    func getValue(key: String) -> String?
    func setValue(value: String, forKey key: String, expires: Double?)
    
    func remove(key: String)
    func clear()
    
}
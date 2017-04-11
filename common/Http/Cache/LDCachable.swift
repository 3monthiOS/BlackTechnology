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
    
    func get(_ key: String) -> LDCacheItem?
    func set(_ value: LDCacheItem)
    
    func getValue(_ key: String) -> String?
    func setValue(_ value: String, forKey key: String, expires: Double?)
    
    func remove(_ key: String)
    func clear()
    
}

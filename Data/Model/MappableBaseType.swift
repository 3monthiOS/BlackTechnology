//
//  MappableBaseType.swift
//  grapefruit
//
//  Created by Cator Vee on 2/21/16.
//  Copyright © 2016 Ledong. All rights reserved.
//

import Foundation
import ObjectMapper

class MappableBaseType<T> : Mappable {
    
    var value: T?
    
    required init?(map: Map) {
        if let val = map.currentValue as? T {
            value = val
        }
    }
    
    func mapping(map: Map) {
        // nothing
    }
}

//
//  TestModel.swift
//  App
//
//  Created by 红军张 on 2017/4/25.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation
import ObjectMapper

public class MessageWrapper<T: Mappable>: Mappable {
    public var code = -1
    public var msg: T?
    public var token: String?
    
    public required init?(map: Map) {
        // nothing
    }
    
    public func mapping(map: Map) {
        code <- map["code"]
        msg <- map["msg"]
        token <- map["token"]
    }
}

class MessageBody: Mappable {
    var name: String?
    var age: Int?
    
    required init?(map: Map) {
        // nothing
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        age <- map["age"]
    }
}

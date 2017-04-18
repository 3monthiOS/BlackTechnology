//
// Created by Cator Vee on 7/10/16.
// Copyright (c) 2016 Cator Vee. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

open class RestResponse<T:Mappable>: Mappable {
    
    /// HTTP响应的Headers
    open var headers: [AnyHashable: Any]?
    /// HTTP响应返回去的内容
    open var rawData: Data?
    /// `rawData`属性的String对象
    open var rawString: String? {
        return rawData == nil ? nil : String(data: rawData!, encoding: String.Encoding.utf8)
    }
    /// HTTP响应内容的JSON对象
    open var json: JSON? {
        return rawData == nil ? nil : JSON(data: rawData!)
    }

    /// 错误信息
    open var error: RestError?

    /// ObjectMapper原始Map对象
    open var map: Map!
    
    open var code = -1
    open var msg: T?
    open var errorMessage: String?
    
    var isOK: Bool {
        return code == 0 && msg != nil && error == nil
    }

    public init() {
        // nothing
    }
    
    public init(error: RestError) {
        self.error = error
    }

    public required init?(map: Map) {
        self.map = map
    }

    open func mapping(map: Map) {
        code <- map[Rest.responseCodeField]
        errorMessage <- map[Rest.responseErrorMessageField]
        if code == 0 {
            msg <- map[Rest.responseMessageField]
//            let value = map.currentValue
//            if value is String || value is Bool || value is Int || value is Array<AnyObject> {
//                msg = T(map)
//            }
        } else {
            error = .resultError(code: code, message: errorMessage ?? "")
            Log.error("rest: ResultError[\(code)] \(errorMessage ?? "")")
        }
    }
}

open class RestBaseModel: Mappable {
    
    fileprivate var map: Map!
    fileprivate var currentValue: AnyObject?
    
    open var string: String? { return value() }
    open var stringValue: String { return string ?? "" }
    
    open var bool: Bool? { return value() }
    open var boolValue: Bool { return bool ?? false }
    
    open var int: Int? { return value() }
    open var intValue: Int { return int ?? 0 }
    
    open var double: Double? { return value() }
    open var doubleValue: Double { return double ?? 0.0 }
    
    public required init?(map: Map) {
        self.map = map
        self.currentValue = map.currentValue as AnyObject
    }
    
    open func mapping(map: Map) {
        
    }
    
    open func value<T>() -> T? {
        if let value = currentValue as? T {
            return value
        }
        return nil
    }
    
    open subscript(key: String) -> AnyObject? {
        guard map != nil && map.isKeyPresent else { // isKeyPresent 这里有个疑问 这个值是否该加
            return nil
        }
        var result: AnyObject?
        result <- map[key]
        return result
    }
}

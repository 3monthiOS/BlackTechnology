//
//  Stringify.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - JSON

extension String {
  /// String to JSON
  public var json: JSON {
    return JSON(parseJSON: self)
  }
}

extension JSON {
  /// JSON to String
  public var jsonString: String {
    return rawString(.utf8, options: JSONSerialization.WritingOptions()) ?? ""
  }
}

// MARK: - Data

extension String {
  /// 返回UTF8字符集的Data对象
  public var data: Data {
    return self.data(using: .utf8, allowLossyConversion: false)!
  }
}

extension Data {
  /// 返回UTF8字符串
  public var string: String {
    return String(data: self, encoding: .utf8) ?? ""
  }
}

// MARK: - Int, Float, Double, Bool

extension String {
  public var intValue: Int {
    return (self as NSString).integerValue
  }
  
  public var int32Value: Int32 {
    return (self as NSString).intValue
  }
  
  public var int64Value: Int64 {
    return (self as NSString).longLongValue
  }

  public var floatValue: Float {
    return (self as NSString).floatValue
  }

  public var doubleValue: Double {
    return (self as NSString).doubleValue
  }

  public var boolValue: Bool {
    return (self as NSString).boolValue
  }
}

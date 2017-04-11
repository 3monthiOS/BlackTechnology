//
//  Date+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

// MARK: DateFormatter

extension DateFormatter {
  /// 初始化DateFormatter时，传递dataFormat属性值
  public convenience init(dateFormat: String) {
    self.init()
    self.dateFormat = dateFormat
  }
}

// MARK: Format

extension Date {
  /// 获取DateComponents，包含：年 月 日 时 分 秒 周
  public func components(_ units: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second, .weekday]) -> DateComponents {
    return Calendar.current.dateComponents(units, from: self)
  }
  
  public func component(_ unit: Calendar.Component) -> Int {
    return Calendar.current.component(unit, from: self)
  }
  
  /// 从格式化的字符串中创建日期对象
  public init?(string: String, format: String = "yyyy-MM-dd HH:mm:ss") {
    if let date = DateFormatter(dateFormat: format).date(from: string) {
      self = date
    } else {
      return nil
    }
  }
}

extension String {
  /// 日期格式化成字符串
  public init(_ date: Date, format: String = "yyyy-MM-dd HH:mm:ss") {
    self = DateFormatter(dateFormat: format).string(from: date)
  }
}

// MARK: Properties

extension Date {
  /// Unix Timestamp: 从格林威治时间1970年01月01日00时00分00秒起至现在的总秒数
  public var unixTimestamp: Int {
    return Int(self.timeIntervalSince1970)
  }
  
  /// Timestamp: 从格林威治时间1970年01月01日00时00分00秒起至现在的总豪秒数
  public var timestamp: Int64 {
    return Int64(self.timeIntervalSince1970 * 1000)
  }
  
}

// 日期加减运算 @see SwiftDate https://github.com/malcommac/SwiftDate

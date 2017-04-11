//
//  Log.swift
//  Swiften
//
//  Created by Cator Vee on 5/25/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

public struct Log {
  private static let dateFormatter = DateFormatter(dateFormat: "HH:mm:ss.SSS")
  
  public static let LEVEL_NONE    = 0
  public static let LEVEL_ERROR   = 1
  public static let LEVEL_WARN    = 2
  public static let LEVEL_INFO    = 3
  public static let LEVEL_DEBUG   = 4
  
  public static var level = LEVEL_DEBUG
  
  fileprivate static func printMessage<T>(_ level: String, message: T, column: Int, line: Int, function: String, file: String) {
    let time = dateFormatter.string(from: Date())
    
    let filename: String
    if let pos = file.range(of: "/", options: .backwards)?.lowerBound {
      filename = file.substring(from: file.index(after: pos))
    } else {
      filename = file
    }
    
    let thread = Thread.current
    var threadDesc: String
    if thread.isMainThread {
      threadDesc = "main"
    } else if let threadName = thread.name {
      threadDesc = threadName
    } else {
      threadDesc = ""
    }
    if let threadNum = thread.value(forKeyPath: "private.seqNum") as? Int {
      threadDesc += "#\(threadNum)"
    }
    if !threadDesc.isEmpty {
      threadDesc += " "
    }
    print("\(time) \(threadDesc)[\(level)] \(message) in \(function) \(filename):\(line):\(column)")
  }
  
  public static func debug<T>(_ message: @autoclosure () -> T, column: Int = #column, line: Int = #line, function: String = #function, file: String = #file) {
    guard level >= LEVEL_DEBUG else { return }
    printMessage("DEBUG", message: message(), column: column, line: line, function: function, file: file)
  }
  
  public static func info<T>(_ message: @autoclosure () -> T, column: Int = #column, line: Int = #line, function: String = #function, file: String = #file) {
    guard level >= LEVEL_INFO else { return }
    printMessage("INFO", message: message(), column: column, line: line, function: function, file: file)
  }
  
  public static func warn<T>(_ message: @autoclosure () -> T, column: Int = #column, line: Int = #line, function: String = #function, file: String = #file) {
    guard level >= LEVEL_WARN else { return }
    printMessage("WARN", message: message(), column: column, line: line, function: function, file: file)
  }
  
  public static func error<T>(_ message: @autoclosure () -> T, column: Int = #column, line: Int = #line, function: String = #function, file: String = #file) {
    guard level >= LEVEL_ERROR else { return }
    printMessage("ERROR", message: message(), column: column, line: line, function: function, file: file)
  }
}

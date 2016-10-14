//
//  Log.swift
//  Swiften
//
//  Created by Cator Vee on 5/25/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

public struct Log {
    private static var dateFormatter: NSDateFormatter!

    public static let LEVEL_ALL     = 0xFF
    public static let LEVEL_DEBUG   = 1 << 0
    public static let LEVEL_INFO    = 1 << 1
    public static let LEVEL_WARN    = 1 << 2
    public static let LEVEL_ERROR   = 1 << 3

    public static var level = LEVEL_ALL

    private static func printMessage<T>(level: String, message: T, column: Int, line: Int, function: String, file: String) {
        if dateFormatter == nil {
            dateFormatter = NSDateFormatter(coder: "HH:mm:ss.SSS")
        }

        let time = dateFormatter.stringFromDate(NSDate())

        let filename: String
        if let pos = file.rangeOfString("/", options: .BackwardsSearch)?.startIndex {
            filename = file.substringFromIndex(pos.advancedBy(1))
        } else {
            filename = file
        }

        let thread = NSThread.currentThread()
        var threadDesc: String
        if thread.isMainThread {
            threadDesc = "main"
        } else if let threadName = thread.name {
            threadDesc = threadName
        } else {
            threadDesc = ""
        }
        if let threadNum = thread.valueForKeyPath("private.seqNum")?.integerValue {
            threadDesc += "#\(threadNum)"
        }
        if !threadDesc.isEmpty {
            threadDesc += " "
        }
        print("\(time) \(threadDesc)[\(level)] \(message) in \(function) \(filename):\(line):\(column)")
    }

    public static func debug<T>(@autoclosure message: () -> T, column: Int = #column, line: Int = #line, function: String = #function, file: String = #file) {
        guard level & LEVEL_DEBUG != 0 else { return }
        printMessage("DEBUG", message: message(), column: column, line: line, function: function, file: file)
    }

    public static func info<T>(@autoclosure message: () -> T, column: Int = #column, line: Int = #line, function: String = #function, file: String = #file) {
        guard level & LEVEL_INFO != 0 else { return }
        printMessage("INFO", message: message(), column: column, line: line, function: function, file: file)
    }

    public static func warn<T>(@autoclosure message: () -> T, column: Int = #column, line: Int = #line, function: String = #function, file: String = #file) {
        guard level & LEVEL_WARN != 0 else { return }
        printMessage("WARN", message: message(), column: column, line: line, function: function, file: file)
    }

    public static func error<T>(@autoclosure message: () -> T, column: Int = #column, line: Int = #line, function: String = #function, file: String = #file) {
        guard level & LEVEL_ERROR != 0 else { return }
        printMessage("ERROR", message: message(), column: column, line: line, function: function, file: file)
    }
}

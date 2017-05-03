//
//  String+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/23/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
//import CommonCrypto


// MARK:   index 转换 int
extension String
{
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = range.lowerBound.samePosition(in: utf16view)
        let to = range.upperBound.samePosition(in: utf16view)
        return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from),
                           utf16view.distance(from: from, to: to))
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}
// MARK: Length
extension String {
    /// 字符串长度
    public var length: Int { return self.characters.count }
}

// MARK: URL encode/decode

extension String {
    /// URL编码
    public var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? self
    }
    
    public var urlEncodingWithQueryAllowedCharacters: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
    /// URL解码
    public var urlDecoded: String {
        return self.removingPercentEncoding ?? self
    }
}

// MARK: Alamofire 4 Swift 3 ParameterEncoding Custom
extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

// MARK: Base64
extension String {
    /// Base64编码
    public var base64Encoded: String {
        return data.base64EncodedString(options: [])
    }
    
    /// Base64解码
    public var base64Decoded: String {
        return Data(base64Encoded: self, options: [])?.string ?? ""
    }
}

// MARK: Get the size of the text

extension String {
    /// 计算制定字体大小的文字显示尺寸（系统默认字体）
    public func size(fontSize: CGFloat, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        return size(font: UIFont.systemFont(ofSize: fontSize), width: width)
    }
    
    /// 计算制定字体的文字显示尺寸
    public func size(font: UIFont, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyle.copy()
        ]

        return (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
}

// MARK: Substring
extension String {
    public func index(at position: Int) -> Index? {
        if position < 0 {
            return nil
        }
        return index(startIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    public func substring(_ fromIndex: Int, _ toIndex: Int = Int.max) -> String? {
        let len = length
        var start: Int
        var end: Int
        if fromIndex < 0 {
            start = len + fromIndex
            end = len
        } else {
            start = fromIndex
            if toIndex < 0 {
                end = len + toIndex
            } else {
                end = toIndex
            }
        }
        
        if start > end {
            return nil
        }
        
        return self[start..<min(end, len)]
    }
    
    public subscript(range: ClosedRange<Int>) -> String? {
        get {
            return self[range.lowerBound..<range.upperBound+1]
        }
        set {
            self[range.lowerBound..<range.upperBound+1] = newValue
        }
    }
    
    public subscript(range: Range<Int>) -> String? {
        get {
            guard let start = index(at: range.lowerBound),
                let end = index(at: range.upperBound)
                else {
                    return nil
            }
            return self[start..<end]
        }
        set {
            guard let start = index(at: range.lowerBound),
                let end = index(at: range.upperBound)
                else {
                    return
            }
            if let value = newValue {
                replaceSubrange(start..<end, with: value)
            } else {
                removeSubrange(start..<end)
            }
        }
    }
    
    public subscript(position: Int) -> Character? {
        get {
            guard let index = index(at: position) else {
                return nil
            }
            return self[index]
        }
        set {
            guard let index = index(at: position) else {
                return
            }
            if let value = newValue {
                replaceSubrange(index...index, with: String(value))
            } else {
                remove(at: index)
            }
        }
    }
}

// MARK: Trim
extension String {
    /// 删除前后空白符（包含空格、Tab、回车、换行符）
    public var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

// MARK: Localized String
extension String {
    public var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
}

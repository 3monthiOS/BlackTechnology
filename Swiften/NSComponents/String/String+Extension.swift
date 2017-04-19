//
//  String+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/23/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import UIKit
//import CommonCrypto

/*
     index 转换 int
 */
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

// MARK: Digest

extension String {
    public var md5: String {
        let data = self.data
        var digest = [UInt8](repeating: 0 , count: Int(CC_MD5_DIGEST_LENGTH))
        let bytes = data.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
        }
        CC_MD5(bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined(separator: "")
    }
    
//    public var sha1: String {
//        let data = self.data
//        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
//        let bytes = data.withUnsafeBytes {
//            [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
//        }
//        CC_SHA1(bytes, CC_LONG(data.count), &digest)
//        let hexBytes = digest.map { String(format: "%02hhx", $0) }
//        return hexBytes.joined(separator: "")
//    }
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
    public func substring(_ fromIndex: Int, _ toIndex: Int = Int.max) -> String? {
        let len = self.length
        var start: Int
        var end: Int
        if fromIndex < 0 {
            start = 0
            end = len + fromIndex
        } else {
            start = fromIndex
            if toIndex < 0 {
                end = len + toIndex
            } else {
                end = min(toIndex, len)
            }
        }
        
        if start > end {
            return nil
        }
        
        return self[start..<end]
    }
    
    public subscript(range: Range<Int>) -> String? {
        let len = self.length
        if range.lowerBound >= len || range.upperBound < 0 {
            return nil
        }
        
        let startIndex = self.characters.index(self.startIndex, offsetBy: max(0, range.lowerBound))
        let endIndex = self.characters.index(self.startIndex, offsetBy: min(len, range.upperBound))
        
        return self[startIndex..<endIndex]
    }
    
    public subscript(index: Int) -> Character? {
        if index < 0 || index >= self.length {
            return nil
        }
        return self[self.characters.index(self.startIndex, offsetBy: index)]
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

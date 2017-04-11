//
//  String+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/23/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import CommonCrypto

// MARK: Length
extension String {
  /// 字符串长度
  public var length: Int {
    return self.characters.count
  }
}

// MARK: URL encode/decode

extension String {
  /// URL编码
  public var urlEncoded: String {
    return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet(charactersIn: "!*'\\\"();:@&=+$,/?%#[]% ").inverted) ?? self
  }
  /// URL解码
  public var urlDecoded: String {
    return self.removingPercentEncoding ?? self
  }
}

// MARK: Digest

extension String {
  public var md5: String {
    return data.md5.hexString
  }
  
  public var sha1: String {
    return data.sha1.hexString
  }
}

// MARK: Base64

extension String {
  /// Base64编码
  public var base64Encoded: String {
    return data.base64EncodedString()
  }
  
  /// Base64解码
  public var base64Decoded: String {
    return Data(base64Encoded: self)?.string ?? ""
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
  public var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}

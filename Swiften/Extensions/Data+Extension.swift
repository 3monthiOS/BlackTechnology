//
//  Data+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 18/02/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import Foundation
import CommonCrypto

extension Data {
  
  private static let hexChars: [Character] = [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"
  ]
  
  public var hexString: String {
    var chars = [Character](repeating: "0", count: count * 2)
    for (index, byte) in enumerated() {
      chars[index * 2] = Data.hexChars[Int(byte / 16)]
      chars[index * 2 + 1] = Data.hexChars[Int(byte % 16)]
    }
    return String(chars)
    /* same as: return map { String(format: "%02hhx", $0) }.joined() */
  }
  
  public init?(hexString: String) {
    guard let data = hexString.data(using: .ascii), data.count % 2 == 0 else {
      return nil
    }
    var bytes = [UInt8](repeating: 0, count: data.count / 2)
    var char: UInt8 = 0
    for (index, byte) in data.enumerated() {
      let value: UInt8
      switch byte {
      case 48..<58:   // 0...9
        value = byte - 48
      case 97..<97+6: // a...f
        value = byte - 97 + 10
      case 65..<65+6: // A...F
        value = byte - 65 + 10
      default:
        return nil
      }
      if index % 2 == 0 {
        char = value * 16
      } else {
        bytes[index / 2] = char + value
      }
    }
    self = Data(bytes: bytes)
  }
  
  public var md5: Data {
    var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5((self as NSData).bytes, CC_LONG(self.count), &digest)
    return Data(bytes: digest)
  }
  
  public var sha1: Data {
    var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
    CC_SHA1((self as NSData).bytes, CC_LONG(self.count), &digest)
    return Data(bytes: digest)
  }
  
}

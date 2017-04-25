//
//  ContentType.swift
//  Swiften
//
//  Created by Cator Vee on 24/02/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import Foundation

public struct ContentType: CustomStringConvertible {
  
  public static let octetStream     = ContentType(type: "application", subtype: "octet-stream")
  public static let json            = ContentType(type: "application", subtype: "json", suffix: ".json")
  public static let javascript      = ContentType(type: "application", subtype: "javascript", suffix: ".js")
  public static let formUrlEncoded  = ContentType(type: "application", subtype: "x-www-form-urlencoded")
  public static let formData        = ContentType(type: "multipart", subtype: "form-data")
  public static let html            = ContentType(type: "text", subtype: "html", suffix: ".html")
  public static let css             = ContentType(type: "text", subtype: "css", suffix: ".css")
  public static let xml             = ContentType(type: "text", subtype: "xml", suffix: ".xml")
  public static let text            = ContentType(type: "text", subtype: "plain", suffix: ".txt")
  public static let png             = ContentType(type: "image", subtype: "png", suffix: ".png")
  public static let jpeg            = ContentType(type: "image", subtype: "jpeg", suffix: ".jpeg")
  public static let gif             = ContentType(type: "image", subtype: "gif", suffix: ".gif")
	
	public static let unknown         = ContentType(type: "*", subtype: "*", suffix: "")
  
  public var description: String {
    if let charset = charset {
      return "\(type)/\(subtype); charset=\(charset)"
    } else {
      return "\(type)/\(subtype)"
    }
  }
  
  public let type: String
  public let subtype: String
  public let charset: String?
  
  public var suffix: String?
  
  public init(_ string: String) {
    let rawValue = string.lowercased()
    
    let mimeType: String
    let parameter: String?
    if rawValue.contains(";") {
      let components = rawValue.components(separatedBy: ";")
      mimeType = components[0]
      parameter = components[1]
    } else {
      mimeType = rawValue
      parameter = nil
    }
		
		var type: String
		var subtype: String
    if mimeType.contains("/") {
      let components = mimeType.components(separatedBy: "/")
      type = components[0].trimmed
      subtype = components[1].trimmed
    } else {
      type = mimeType.trimmed
      subtype = "*"
    }
		self.type = type.isEmpty ? "*" : type
		self.subtype = subtype.isEmpty ? "*" : subtype
    
    if let parameter = parameter, parameter.contains("=") {
      let components = parameter.components(separatedBy: "=")
      if components[0].trimmed == "charset" {
        charset = components[1].trimmed
      } else {
        charset = nil
      }
    } else {
      charset = nil
    }
  }
  
  public init(type: String, subtype: String, charset: String? = nil, suffix: String? = nil) {
    self.type = type.lowercased()
    self.subtype = subtype.lowercased()
    if let charset = charset?.lowercased() {
      switch charset {
      case "utf8":  self.charset = "utf-8"
      default:      self.charset = charset
      }
    } else {
      self.charset = nil
    }
    self.suffix = suffix
  }
  
  public func with(charset: String) -> ContentType {
    return ContentType(type: type, subtype: subtype, charset: charset)
  }
  
  public func isCompatible(with other: ContentType) -> Bool {
    return (self.type == other.type || self.type == "*" || other.type == "*")
      &&   (self.subtype == other.subtype || self.subtype == "*" || other.subtype == "*")
      &&   (self.charset == nil || other.charset == nil || self.charset == other.charset)
  }
  
  public static func ==(lhs: ContentType, rhs: ContentType) -> Bool {
    return lhs.type == rhs.type && lhs.subtype == rhs.subtype && lhs.charset == rhs.charset
  }
  
}

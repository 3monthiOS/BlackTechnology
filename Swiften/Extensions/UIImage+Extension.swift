//
//  UIImage+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/25/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

// TODO: 支持GIF动画

// MARK: Data

extension UIImage {
  public var data: Data? {
		if contentType == .jpeg {
      return UIImageJPEGRepresentation(self, 1)
		} else if contentType == .png {
      return UIImagePNGRepresentation(self)
		} else if contentType == .gif {
			//  return UIImageAnimatedGIFRepresentation(self)
		}
		return nil
  }
}

// MARK: Content Type

extension UIImage {
  fileprivate struct AssociatedKey {
    static var contentType: Int = 0
  }
	
	public static func contentType(from imageData: Data?) -> ContentType {
		guard let data = imageData else { return .unknown }
		
		var c = [UInt8](repeating: 0, count: 1)
		data.copyBytes(to: &c, count: 1)
		
		switch (c[0]) {
		case 0xFF:
			return .jpeg
		case 0x89:
			return .png
		case 0x47:
			return .gif
//		case 0x49, 0x4D:
//			return .tiff
//		case 0x52:
//			// R as RIFF for WEBP
//			if data.count >= 12 {
//				let startIndex = data.index(data.startIndex, offsetBy: 8)
//				let endIndex = data.index(startIndex, offsetBy: 4)
//				if let type = String(data: data.subdata(in: startIndex..<endIndex), encoding: .ascii) {
//					if type.hasPrefix("RIFF") && type.hasSuffix("WEBP") {
//						return .webp
//					}
//				}
//			}
		default:
			break
		}
		return .unknown
	}

	
  public var contentType: ContentType {
    get {
      let value = objc_getAssociatedObject(self, &AssociatedKey.contentType) as? String ?? ""
      if value.isEmpty {
        var result: ContentType
        //if let _ = UIImageAnimatedGIFRepresentation(self) {
        //result = .gif
        //} else
        if UIImageJPEGRepresentation(self, 1) != nil {
          result = .jpeg
        } else if UIImagePNGRepresentation(self) != nil {
          result = .png
        } else {
          result = .unknown
        }
        objc_setAssociatedObject(self, &AssociatedKey.contentType, result.description, .OBJC_ASSOCIATION_RETAIN)
        return result
      }
      let result = ContentType(value)
			if result == .jpeg {
				return .jpeg
			} else if result == .png {
				return .png
			} else if result == .gif {
				return .gif
			} else {
				return .unknown
			}
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKey.contentType, newValue.description, .OBJC_ASSOCIATION_RETAIN)
    }
  }
  
  convenience init?(data: Data, contentType: ContentType) {
    self.init(data: data)
		if contentType == .unknown {
			self.contentType = UIImage.contentType(from: data)
		} else {
			self.contentType = contentType
		}
  }
}

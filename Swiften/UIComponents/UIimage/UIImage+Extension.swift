//
//  UIImage+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/25/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import UIKit
// MARK: Data

extension UIImage {
    public var data: NSData? {
        switch contentType {
        case .JPEG:
            return UIImageJPEGRepresentation(self, 1) as NSData?
        case .PNG:
            return UIImagePNGRepresentation(self) as NSData?
        //case .GIF:
            //return UIImageAnimatedGIFRepresentation(self)
        default:
            return nil
        }
    }
}

// MARK: Content Type

extension UIImage {
    private struct AssociatedKey {
        static var contentType: Int = 0
    }
    
    public enum ContentType: Int {
        case Unknown = 0, PNG, JPEG, GIF, TIFF, WEBP
        
        public var mimeType: String {
            switch self {
            case .JPEG: return "image/jpeg"
            case .PNG:  return "image/png"
            case .GIF:  return "image/gif"
            case .TIFF: return "image/tiff"
            case .WEBP: return "image/webp"
            default:    return ""
            }
        }
        
        public var extendName: String {
            switch self {
            case .JPEG: return ".jpg"
            case .PNG:  return ".png"
            case .GIF:  return ".gif"
            case .TIFF: return ".tiff"
            case .WEBP: return ".webp"
            default:    return ""
            }
        }
        
        
        public static func contentType(mimeType: String?) -> ContentType {
            guard let mime = mimeType else { return .Unknown }
            switch mime {
            case "image/jpeg": return .JPEG
            case "image/png":  return .PNG
            case "image/gif":  return .GIF
            case "image/tiff": return .TIFF
            case "image/webp": return .WEBP
            default:           return .Unknown
            }
        }
        
        public static func contentTypeWithImageData(imageData: NSData?) -> ContentType {
            guard let data = imageData else { return .Unknown }
            
//            var c = [UInt32](count: 1, repeatedValue: 0)
            var c = [UInt32](repeating: 0, count: 1)
            data.getBytes(&c, length: 1)
            
            switch (c[0]) {
            case 0xFF:
                return .JPEG
            case 0x89:
                return .PNG
            case 0x47:
                return .GIF
            case 0x49, 0x4D:
                return .TIFF
            case 0x52:
                // R as RIFF for WEBP
                if data.length >= 12 {
                    if let type = String(data: data.subdata(with: NSMakeRange(0, 12)), encoding: String.Encoding.ascii) {
                        if type.hasPrefix("RIFF") && type.hasSuffix("WEBP") {
                            return .WEBP
                        }
                    }
                }
                
            default: break
            }
            return .Unknown
        }
    }
    
    public var contentType: ContentType {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKey.contentType) as? Int ?? 0
            if value == 0 {
                var result: ContentType
                //if let _ = UIImageAnimatedGIFRepresentation(self) {
                    //result = .GIF
                //} else
                if let _ = UIImageJPEGRepresentation(self, 1) {
                    result = .JPEG
                } else if let _ = UIImagePNGRepresentation(self) {
                    result = .PNG
                } else {
                    result = .Unknown
                }
                objc_setAssociatedObject(self, &AssociatedKey.contentType, result.rawValue, .OBJC_ASSOCIATION_RETAIN)
                return result
            }
            return ContentType(rawValue: value) ?? .Unknown
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.contentType, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    convenience init?(data: NSData, contentType: ContentType) {
        self.init(data: data as Data)
        self.contentType = contentType
    }
}

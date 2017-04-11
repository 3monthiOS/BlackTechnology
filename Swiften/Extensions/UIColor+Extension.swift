//
//  UIColor+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

extension UIColor {
  
  public convenience init(r: UInt32, g: UInt32, b: UInt32, alpha: CGFloat = 1.0) {
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
  }
  
	public convenience init(rgb: UInt32, alpha: CGFloat = 1) {
    self.init(r: rgb >> 16, g: rgb >> 8 & 0xFF, b: rgb & 0xFF, alpha: alpha)
  }
  
  public convenience init(rgba: UInt32) {
    self.init(r: rgba >> 24, g: rgba >> 16 & 0xFF, b: rgba >> 8 & 0xFF, alpha: CGFloat(rgba & 0xFF) / 255)
  }
  
}

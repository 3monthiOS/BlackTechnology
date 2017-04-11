//
//  CGRect+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

extension CGRect {
  
  public var center: CGPoint {
    get {
      return CGPoint(x: self.midX, y: self.midY)
    }
    set {
      self.origin.x = newValue.x - self.size.width / 2
      self.origin.y = newValue.y - self.size.height / 2
    }
  }
  
}

//
//  CALayer+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

extension CALayer {
  func setBorderUIColor(_ color: UIColor) {
    self.borderColor = color.cgColor
  }
}

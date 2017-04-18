//
//  CGRect+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

extension CGRect {
    public var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

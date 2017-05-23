//
//  File.swift
//  App
//
//  Created by 红军张 on 2017/5/19.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation
import UIKit

/// The RAMLeftRotationAnimation class provides letf rotation animation.
class ChatTabbarItem : RAMRotationAnimation {
    
    override init() {
        super.init()
        direction = RAMRotationDirection.left
    }
}


//
//  UIView+SetRect.swift
//  YouXianMing
//
//  Created by YouXianMing on 15/9/29.
//  Copyright © 2015年 YouXianMing All rights reserved.
//

import UIKit

/**
 UIScreen width.
 
 - returns: Screen width.
 */
public func Width() -> CGFloat {

    return UIScreen.main.bounds.size.width
}

/**
 UIScreen height.
 
 - returns: Screen height.
 */
public func Height() -> CGFloat {

    return UIScreen.main.bounds.size.height
}

/// Status bar height.
public let StatusBarHeight                 : CGFloat = 20

/// Navigation bar height.
public let NavigationBarHeight             : CGFloat = 44

/// Tabbar height.
public let TabbarHeight                    : CGFloat = 49

/// Status bar & navigation bar height.
public let StatusBarAndNavigationBarHeight : CGFloat = StatusBarHeight + NavigationBarHeight




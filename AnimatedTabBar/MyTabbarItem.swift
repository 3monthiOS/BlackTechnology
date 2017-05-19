//
//  MyTabbarItem.swift
//  App
//
//  Created by 红军张 on 2017/5/19.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation

import RAMAnimatedTabBarController

class MyTabbarItem: RAMItemAnimation {
    
    /**
     Start animation, method call when UITabBarItem is selected
     
     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     */
    override open func playAnimation(_ icon : UIImageView, textLabel : UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }
    
    /**
     Start animation, method call when UITabBarItem is unselected
     
     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     - parameter defaultTextColor: default UITabBarItem text color
     - parameter defaultIconColor: default UITabBarItem icon color
     */
    override open func deselectAnimation(_ icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor, defaultIconColor: UIColor) {
        textLabel.textColor = defaultTextColor
        
        if let iconImage = icon.image {
            let renderMode = defaultIconColor.cgColor.alpha == 0 ? UIImageRenderingMode.alwaysOriginal :
                UIImageRenderingMode.alwaysTemplate
            let renderImage = iconImage.withRenderingMode(renderMode)
            icon.image = renderImage
            icon.tintColor = defaultIconColor
        }
    }
    
    /**
     Method call when TabBarController did load
     
     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     */
    override open func selectedState(_ icon : UIImageView, textLabel : UILabel) {
        textLabel.textColor = textSelectedColor
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }
    }
    
    func playBounceAnimation(_ icon : UIImageView) {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: Constant.AnimationKeys.Scale)
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        icon.layer.add(bounceAnimation, forKey: nil)
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }
    }
}

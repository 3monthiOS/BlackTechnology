//
//  FunctionTabbarItem.swift
//  App
//
//  Created by 红军张 on 2017/5/19.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation


class FunctionTabbarItem: RAMItemAnimation {
    
    /**
     Start animation, method call when UITabBarItem is selected
     
     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     */
    override open func playAnimation(_ icon : UIImageView, textLabel : UILabel) {
        playMoveIconAnimation(icon, values:[icon.center.y as AnyObject, (icon.center.y + 4.0) as AnyObject])
        playLabelAnimation(textLabel)
        textLabel.textColor = textSelectedColor
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = textSelectedColor
        }
    }
    /**
     Start animation, method call when UITabBarItem is unselected
     
     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     - parameter defaultTextColor: default UITabBarItem text color
     - parameter defaultIconColor: default UITabBarItem icon color
     */
    override open func deselectAnimation(_ icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor, defaultIconColor : UIColor) {
        
        playMoveIconAnimation(icon, values:[(icon.center.y + 4.0) as AnyObject, icon.center.y as AnyObject])
        playDeselectLabelAnimation(textLabel)
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
        
        playMoveIconAnimation(icon, values:[(icon.center.y + 12.0) as AnyObject])
        textLabel.alpha = 0
        textLabel.textColor = textSelectedColor
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = textSelectedColor
        }
    }
    
    func playMoveIconAnimation(_ icon : UIImageView, values: [AnyObject]) {
        
        let yPositionAnimation = createAnimation(Constants.AnimationKeys.PositionY, values:values, duration:duration / 2)
        
        icon.layer.add(yPositionAnimation, forKey: nil)
    }
    
    // MARK: select animation
    
    func playLabelAnimation(_ textLabel: UILabel) {
        
        let yPositionAnimation = createAnimation(Constants.AnimationKeys.PositionY, values:[textLabel.center.y as AnyObject, (textLabel.center.y - 60.0) as AnyObject], duration:duration)
        yPositionAnimation.fillMode = kCAFillModeRemoved
        yPositionAnimation.isRemovedOnCompletion = true
        textLabel.layer.add(yPositionAnimation, forKey: nil)
        
        let scaleAnimation = createAnimation(Constants.AnimationKeys.Scale, values:[1.0 as AnyObject ,2.0 as AnyObject], duration:duration)
        scaleAnimation.fillMode = kCAFillModeRemoved
        scaleAnimation.isRemovedOnCompletion = true
        textLabel.layer.add(scaleAnimation, forKey: nil)
        
        let opacityAnimation = createAnimation(Constants.AnimationKeys.Opacity, values:[1.0 as AnyObject ,0.0 as AnyObject], duration:duration)
        textLabel.layer.add(opacityAnimation, forKey: nil)
    }
    
    func createAnimation(_ keyPath: String, values: [AnyObject], duration: CGFloat)->CAKeyframeAnimation {
        
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.values = values
        animation.duration = TimeInterval(duration)
        animation.calculationMode = kCAAnimationCubic
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    // MARK: deselect animation
    
    func playDeselectLabelAnimation(_ textLabel: UILabel) {
        
        let yPositionAnimation = createAnimation(Constants.AnimationKeys.PositionY, values:[(textLabel.center.y + 15) as AnyObject, textLabel.center.y as AnyObject], duration:duration)
        textLabel.layer.add(yPositionAnimation, forKey: nil)
        
        let opacityAnimation = createAnimation(Constants.AnimationKeys.Opacity, values:[0 as AnyObject, 1 as AnyObject], duration:duration)
        textLabel.layer.add(opacityAnimation, forKey: nil)
    }
}

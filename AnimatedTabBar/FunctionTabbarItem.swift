//
//  FunctionTabbarItem.swift
//  App
//
//  Created by 红军张 on 2017/5/19.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation

import RAMAnimatedTabBarController

class FunctionTabbarItem: RAMItemAnimation {
    
    @nonobjc fileprivate var animationImages : Array<CGImage> = Array()
    
    var selectedImage : UIImage!
    
    /// A Boolean value indicated plaing revers animation when UITabBarItem unselected, if false image change immediately, defalut value true
    @IBInspectable open var isDeselectAnimation: Bool = true
    
    /// path to array of image names from plist file
    let imagesPath = "ToolsAnimation"
    
    override open func awakeFromNib() {
        
        guard let path = Bundle.main.path(forResource: imagesPath, ofType:"plist") else {
            fatalError("don't found plist")
        }
        
        guard case let animationImagesName as [String] = NSArray(contentsOfFile: path) else {
            fatalError()
        }
        
        createImagesArray(animationImagesName)
        
        // selected image
        let selectedImageName = animationImagesName[animationImagesName.endIndex - 1]
        selectedImage = UIImage(named: selectedImageName)
    }
    
    func createImagesArray(_ imageNames : Array<String>) {
        for name : String in imageNames {
            if let image = UIImage(named: name)?.cgImage {
                animationImages.append(image)
            }
        }
    }
    
    // MARK: public
    
    /**
     Set images for keyframe animation
     
     - parameter images: images for keyframe animation
     */
    
    
    open func setAnimationImages(_ images: Array<UIImage>) {
        var animationImages = Array<CGImage>()
        for image in images {
            if let cgImage = image.cgImage {
                animationImages.append(cgImage)
            }
        }
        self.animationImages = animationImages
    }
    
    // MARK: RAMItemAnimationProtocol
    
    /**
     Start animation, method call when UITabBarItem is selected
     
     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     */
    
    
    override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playFrameAnimation(icon, images:animationImages)
        textLabel.textColor = textSelectedColor
    }
    
    /**
     Start animation, method call when UITabBarItem is unselected
     
     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     - parameter defaultTextColor: default UITabBarItem text color
     - parameter defaultIconColor: default UITabBarItem icon color
     */
    
    override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        if isDeselectAnimation {
            playFrameAnimation(icon, images:animationImages.reversed())
        }
        
        textLabel.textColor = defaultTextColor
    }
    
    
    /**
     Method call when TabBarController did load
     
     - parameter icon:      animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     */
    
    override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        icon.image = selectedImage
        textLabel.textColor = textSelectedColor
    }
    
    
    func playFrameAnimation(_ icon : UIImageView, images : Array<CGImage>) {
        let frameAnimation = CAKeyframeAnimation(keyPath: Constant.AnimationKeys.KeyFrame)
        frameAnimation.calculationMode = kCAAnimationDiscrete
        frameAnimation.duration = TimeInterval(duration)
        frameAnimation.values = images
        frameAnimation.repeatCount = 1
        frameAnimation.isRemovedOnCompletion = false
        frameAnimation.fillMode = kCAFillModeForwards
        icon.layer.add(frameAnimation, forKey: nil)
    }
    
}

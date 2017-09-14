//
//  UIButton.swift
//  App
//
//  Created by 红军张 on 2017/9/12.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//


import UIKit
// 图片偏移量
extension UIButton {
    
    func set(image anImage: UIImage?, title: String,
                   titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .center
        self.titleLabel?.contentMode = .center
        self.setImage(anImage, for: state)
        self.setTitle(title, for: state)
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIViewContentMode,
                                             spacing: CGFloat) {
        let titleFont = self.titleLabel?.font!
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleSize = title.size(attributes: [NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: 0,left: -(imageSize.width), bottom: self.frame.size.height/2 - spacing, right: 0)
            imageInsets = UIEdgeInsets(top: self.frame.size.height/2 + spacing, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (self.frame.size.height/2  - spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.frame.size.height/2 - 10 + spacing, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width)*2, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width*2+spacing))
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}

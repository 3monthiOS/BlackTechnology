//
//  SortView.swift
//  App
//
//  Created by 红军张 on 2017/9/8.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class SortView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }
    
    override func layoutSubviews() {
        let y: CGFloat = (self.superview?.frame.height)! - frame.height
        self.frame = frame
        self.frame.origin.y = y
        
        let weight = frame.height / (self.superview?.frame.height)!
        let color = UIColor(hue: weight, saturation: 1, brightness: 1, alpha: 1)
        self.backgroundColor = color
    }
    
    func updateHeight(height: CGFloat) {
        self.frame.size.height = height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

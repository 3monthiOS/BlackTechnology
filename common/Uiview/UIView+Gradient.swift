//
//  UIView+Gradient.swift
//  App
//
//  Created by XiuXiu on 9/22/16.
//  Copyright © 2016 IndependentRegiment. All rights reserved.
//

import Foundation

extension UIView{
  
  func addGradientBackgroundColorWith(edgeColor:UIColor, middleColor middle:UIColor){
    self.backgroundColor = UIColor.clearColor()
    let gradientLayer = CAGradientLayer()
    let rect = self.bounds
    gradientLayer.frame = rect
//    for sub in self.layer.sublayers!{
//        if sub is CAGradientLayer{
//            sub.removeFromSuperlayer()
//        }
//    }
  self.layer.sublayers =  self.layer.sublayers?.filter({!($0 is CAGradientLayer)})
    self.layer.insertSublayer(gradientLayer, atIndex: 0)
    gradientLayer.startPoint = CGPoint(x: 0,y: 0)
    gradientLayer.endPoint = CGPoint(x: 1,y: 1)
    gradientLayer.colors = [edgeColor.CGColor , middle.CGColor ,edgeColor.CGColor]
    gradientLayer.locations = [0 ,0.5 ,1]
  }
}
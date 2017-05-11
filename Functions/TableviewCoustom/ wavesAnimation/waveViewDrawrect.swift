//
//  waveViewDrawrect.swift
//  App
//
//  Created by 红军张 on 2017/5/11.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class waveViewDrawrect: UIView {

    var bigNumber = 0.0
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        // 创建路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        //画水
        context!.setLineWidth(1)
        let blue = UIColor(colorLiteralRed: 210, green: 0, blue: 1, alpha: 0.3).cgColor
        context?.setFillColor(blue)
        
        var y = 0
        let x = Int(rect.size.width)
        for  i in 0 ... x {
            y = Int(-sin(Double(i)/Double(rect.size.width) * Double.pi) * Double(bigNumber) + Double(rect.size.height))
            path.addLine(to: CGPoint(x: i, y: y))
        }
        path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
        path.addLine(to: CGPoint(x: 0, y: rect.size.height))
        
        context?.addPath(path)
        context?.fillPath()
        context?.drawPath(using: .stroke)
        //添加文字
    }
}

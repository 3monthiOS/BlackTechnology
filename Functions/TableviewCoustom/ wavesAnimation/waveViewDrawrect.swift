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
    // 方向 // 默认是纵向
    var direction: UIViewContentMode = .bottom
    
    override func draw(_ rect: CGRect) {
        // 创建画图工具
        let context = UIGraphicsGetCurrentContext()
        // 创建一条画图路径
        let path = CGMutablePath()
        // 制定路径的起始位置
        switch direction {
        case .top:
            path.move(to: CGPoint(x: rect.size.width, y: 0))
        case .bottom:
            path.move(to: CGPoint(x: 0, y: rect.size.height))
        case .left:
            path.move(to: CGPoint(x: 0, y: 0))
        case .right:
            path.move(to: CGPoint(x: rect.size.width, y: rect.size.height))
        default:
            path.move(to: CGPoint(x: 0, y: rect.size.height))
        }
        // 画出来的线的宽度
        context!.setLineWidth(1)
        // 设置线的颜色
        let blue = UIColor(colorLiteralRed: 210, green: 0, blue: 1, alpha: 0.3).cgColor
        context?.setFillColor(blue)
        // 重要的地方： 这个地方开始画图了，仔细看。
        var y = 0,x = 0
        // 纵向：这里的x 有两个意思。即代表 点的x坐标，也代表画多少条线  x = 10 就代表画10条线。 横向：的时候你就把x想成y，y想成x
        switch direction {
        case .top:
            x = Int(rect.size.width)
        case .bottom:
            x = Int(rect.size.width)
        case .left:
            x = Int(rect.size.height)
        case .right:
            x = Int(rect.size.height)
        default:
            x = Int(rect.size.width)
        }
        for  i in 0 ... x { // 这里就是说：画的线的个数和你view的宽度一样
            switch direction {
            case .top:
                // 这里就是 要计算出 y坐标的值，这个你看不懂没关系，只要知道有这个公式就行了。
                y = Int(sin(Double(i)/Double(rect.size.width) * Double.pi) * Double(bigNumber))
                // path 就是那条线，addLine这个方法就是说你给一个终点，它会给你画一条线出来。
                path.addLine(to: CGPoint(x: i, y: y))
                print("x: \(y)  y: \(i)")
            case .bottom:
                // 这里就是 要计算出 y坐标的值，这个你看不懂没关系，只要知道有这个公式就行了。
                y = Int(-sin(Double(i)/Double(rect.size.width) * Double.pi) * Double(bigNumber) + Double(rect.size.height))
                // path 就是那条线，addLine这个方法就是说你给一个终点，它会给你画一条线出来。
                path.addLine(to: CGPoint(x: i, y: y))
            case .left:
                // 这里就是 要计算出 y坐标的值，这个你看不懂没关系，只要知道有这个公式就行了。
                y = Int(sin(Double(i)/Double(rect.size.height) * Double.pi) * Double(bigNumber))
                // path 就是那条线，addLine这个方法就是说你给一个终点，它会给你画一条线出来。
                path.addLine(to: CGPoint(x: y, y: i))
            case .right:
                // 这里就是 要计算出 y坐标的值，这个你看不懂没关系，只要知道有这个公式就行了。
                y = Int(-sin(Double(i)/Double(rect.size.height) * Double.pi) * Double(bigNumber) + Double(rect.size.width))
                // path 就是那条线，addLine这个方法就是说你给一个终点，它会给你画一条线出来。
                path.addLine(to: CGPoint(x: y, y: i))
            default:
                // 这里就是 要计算出 y坐标的值，这个你看不懂没关系，只要知道有这个公式就行了。
                y = Int(-sin(Double(i)/Double(rect.size.width) * Double.pi) * Double(bigNumber) + Double(rect.size.height))
                // path 就是那条线，addLine这个方法就是说你给一个终点，它会给你画一条线出来。
                path.addLine(to: CGPoint(x: i, y: y))
            }
            
        }
        // 截止线（最后一个点的位置，最后这个点的位置会跟起始点的位置连线最终画成一个图形)
        switch direction {
        case .top:
            path.move(to: CGPoint(x: rect.size.width, y: 0))
        case .bottom:
            path.addLine(to: CGPoint(x: 0, y: rect.size.height))
        case .left:
            path.move(to: CGPoint(x: 0, y: 0))
        case .right:
            path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
        default:
            path.addLine(to: CGPoint(x: 0, y: rect.size.height))
        }
        // 把你豁出来的所有线 加到这个画图工具上，合并路径，连接起点和终点，让它给你画出来
        context?.addPath(path)
        // 绘制路径
        context?.fillPath()
        //开始画
        context?.drawPath(using: .stroke)
    }
}

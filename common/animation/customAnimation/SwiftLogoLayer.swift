
import UIKit
import QuartzCore

class SwiftLogoLayer {
  
  //
  // 绘制swiftlogo 形状图层的方法
  //
  class func logoLayer() -> CAShapeLayer {
    let layer = CAShapeLayer()

    //绘制swiftlogo
    let bezierPath = UIBezierPath()
    bezierPath.move(to: CGPoint(x: 96.14, y: 86.59))
    bezierPath.addCurve(to: CGPoint(x: 56.82, y: 94.83), controlPoint1: CGPoint(x: 81.83, y: 85.02), controlPoint2: CGPoint(x: 87.1, y: 95.75))
    bezierPath.addCurve(to: CGPoint(x: 20.01, y: 79.31), controlPoint1: CGPoint(x: 42.17, y: 94.39), controlPoint2: CGPoint(x: 29.06, y: 87.05))
    bezierPath.addCurve(to: CGPoint(x: 5.25, y: 62.38), controlPoint1: CGPoint(x: 10.35, y: 71.06), controlPoint2: CGPoint(x: 5.25, y: 62.38))
    bezierPath.addCurve(to: CGPoint(x: 35.2, y: 74.85), controlPoint1: CGPoint(x: 5.25, y: 62.38), controlPoint2: CGPoint(x: 17.28, y: 72.33))
    bezierPath.addCurve(to: CGPoint(x: 64.02, y: 69.54), controlPoint1: CGPoint(x: 53.11, y: 77.37), controlPoint2: CGPoint(x: 64.02, y: 69.54))
    bezierPath.addCurve(to: CGPoint(x: 37.43, y: 44.73), controlPoint1: CGPoint(x: 64.02, y: 69.54), controlPoint2: CGPoint(x: 49.91, y: 58.13))
    bezierPath.addCurve(to: CGPoint(x: 14.97, y: 16.34), controlPoint1: CGPoint(x: 24.96, y: 31.34), controlPoint2: CGPoint(x: 14.97, y: 16.34))
    bezierPath.addCurve(to: CGPoint(x: 40.56, y: 37.05), controlPoint1: CGPoint(x: 14.97, y: 16.34), controlPoint2: CGPoint(x: 31.85, y: 30.51))
    bezierPath.addCurve(to: CGPoint(x: 56.82, y: 47.75), controlPoint1: CGPoint(x: 45.62, y: 40.86), controlPoint2: CGPoint(x: 56.82, y: 47.75))
    bezierPath.addCurve(to: CGPoint(x: 43.08, y: 32.22), controlPoint1: CGPoint(x: 56.82, y: 47.75), controlPoint2: CGPoint(x: 47.12, y: 37.33))
    bezierPath.addCurve(to: CGPoint(x: 27.99, y: 11.26), controlPoint1: CGPoint(x: 37.51, y: 25.17), controlPoint2: CGPoint(x: 27.99, y: 11.26))
    bezierPath.addCurve(to: CGPoint(x: 55.05, y: 35.46), controlPoint1: CGPoint(x: 27.99, y: 11.26), controlPoint2: CGPoint(x: 45.04, y: 27.34))
    bezierPath.addCurve(to: CGPoint(x: 78.26, y: 52.03), controlPoint1: CGPoint(x: 61.79, y: 40.93), controlPoint2: CGPoint(x: 78.26, y: 52.03))
    bezierPath.addCurve(to: CGPoint(x: 80.71, y: 31.34), controlPoint1: CGPoint(x: 78.26, y: 52.03), controlPoint2: CGPoint(x: 81.63, y: 45.61))
    bezierPath.addCurve(to: CGPoint(x: 69.08, y: 3), controlPoint1: CGPoint(x: 79.8, y: 17.06), controlPoint2: CGPoint(x: 69.08, y: 3))
    bezierPath.addCurve(to: CGPoint(x: 97.29, y: 34.58), controlPoint1: CGPoint(x: 69.08, y: 3), controlPoint2: CGPoint(x: 89.12, y: 14.76))
    bezierPath.addCurve(to: CGPoint(x: 100.25, y: 67.8), controlPoint1: CGPoint(x: 105.45, y: 54.4), controlPoint2: CGPoint(x: 100.25, y: 67.8))
    bezierPath.addCurve(to: CGPoint(x: 107.29, y: 81.07), controlPoint1: CGPoint(x: 100.25, y: 67.8), controlPoint2: CGPoint(x: 104.47, y: 72.3))
    bezierPath.addCurve(to: CGPoint(x: 107.96, y: 96.25), controlPoint1: CGPoint(x: 110.12, y: 89.84), controlPoint2: CGPoint(x: 107.96, y: 96.25))
    bezierPath.addCurve(to: CGPoint(x: 96.14, y: 86.59), controlPoint1: CGPoint(x: 107.96, y: 96.25), controlPoint2: CGPoint(x: 105.27, y: 87.59))
    bezierPath.close()
    
    //create a shape layer
    layer.path = bezierPath.cgPath
    layer.bounds = layer.path!.boundingBox
    
    return layer
  }
  
}

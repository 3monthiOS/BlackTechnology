//
//  DynamicBallVC.swift
//  App
//
//  Created by XiuXiu on 2017/9/7.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import CoreMotion
class DynamicBallVC: UIViewController {

  /// 背景图
  lazy var bg: UIView = {
  let temp = UIView(frame: CGRect(x: 0.0, y: 100, width: self.view.bounds.width, height: 300))
    temp.backgroundColor = UIColor.gray
    self.view.addSubview(temp)
  return temp
  }()
  /// 动画执行者
  lazy var animator: UIDynamicAnimator = {
    let temp = UIDynamicAnimator(referenceView: self.bg)
    return temp
  }()
  /// 动画的重力行为
  lazy var gravity: UIGravityBehavior = {
    let temp = UIGravityBehavior()
    self.animator.addBehavior(temp)
    return temp
  }()
  /// 动画的碰撞行为
  lazy var collision: UICollisionBehavior = {
    let temp = UICollisionBehavior()
    temp.translatesReferenceBoundsIntoBoundary = true
    temp.collisionMode = .everything
    self.animator.addBehavior(temp)
    return temp
  }()
  /// 动画的其他参数
  lazy var itemBehavior: UIDynamicItemBehavior = {
    let temp = UIDynamicItemBehavior()
    // 摩擦系数
    temp.friction = 0.8
    // 质量 size越大 质量越大
    temp.density = 0.5
    // 弹性系数
    temp.elasticity = 0.5
    // 阻力
    temp.resistance = 0
    temp.allowsRotation = true
    self.animator.addBehavior(temp)
    return temp
  }()
  /// 重力感应管理者
  var manager: CMMotionManager = CMMotionManager()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    run()
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    stop()
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "仿摩拜app我的贴纸 动态球"
      view.backgroundColor = UIColor.white
      addBall()
    }
  
  private func addBall() {
    let width = 30
    for i in 0..<5 {
      let Ball = BallImageView(frame: CGRect(x: i * width, y: 0, width: width, height: width))
      let red = CGFloat(arc4random() % 255) / 255
      let green = CGFloat(arc4random() % 255) / 255
      let blue = CGFloat(arc4random() % 255) / 255
      Ball.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
      bg.addSubview(Ball)
      gravity.addItem(Ball)
      collision.addItem(Ball)
      itemBehavior.addItem(Ball)
    }
  }
  private func run() { 
  manager.deviceMotionUpdateInterval = 0.2
    manager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (motion, error) in
      self?.gravity.gravityDirection = CGVector(dx: motion!.gravity.x, dy: motion!.gravity.y)
    }
  }
  private func stop() {
    if manager.isDeviceMotionActive {
      manager.stopDeviceMotionUpdates()
      animator.removeAllBehaviors()
    }
  }
  
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

fileprivate class BallImageView: UIImageView {
  override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
    return .ellipse
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = bounds.width / 2
    layer.masksToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

//
//  CustomAnimation.swift
//  App
//
//  Created by 红军张 on 16/9/12.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import Foundation

class JumpAnimationcontroller: NSObject,UIViewControllerAnimatedTransitioning {
    let animationDuration = 2.0
    weak var storedContext: UIViewControllerContextTransitioning?
    var operation:UINavigationControllerOperation = .Push
    
    var isCustom = false
    var fromeVC = UIViewController()
    var ToVC = UIViewController()
    var Direction = "left"
    var AnimationsOBJ = Animations.Push //默认是push
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if operation == .Push {
            if isCustom{
                customAnimationPush(transitionContext)
            }else{
                storedContext = transitionContext
                let zhuceVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
                zhuceVC?.view.frame = CGRect(x: 0,y: 0,width: App_width,height: App_height)
                transitionContext.containerView().addSubview(zhuceVC!.view)
                specialAnimation(AnimationsOBJ, Direction: Direction, CurrentVc: fromeVC, ForVc: ToVC,isJump: false)
                //        逐渐显现 目的图层动画
                UIView.animateWithDuration(1.0, animations: {
                    zhuceVC?.view.alpha = 1.0
                    }, completion: { (isOK) in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }
        }else{
            if isCustom{
                customAnimationPop(transitionContext)
            }else{
                storedContext = transitionContext
                ToVC.view.alpha = 0
                transitionContext.containerView().addSubview(ToVC.view)
                specialAnimation(AnimationsOBJ, Direction: Direction, CurrentVc: fromeVC, ForVc: ToVC,isJump: false)
                UIView.animateWithDuration(1.0, animations: {
                    self.ToVC.view.alpha = 1.0
                    }, completion: { (isOK) in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }
        }
    }
    // 自定义的动画 push  和 pop
    func customAnimationPush(transitionContext: UIViewControllerContextTransitioning){
        storedContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! LoginviewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! RegisteredViewController
        //        将跳转目的视图控制器的主视图添加到跳转上下文的容器视图中
        transitionContext.containerView().addSubview(toVC.view)
        //        配置变形的图层动画,将logo上移一段距离并放大到150倍
        let animation = CABasicAnimation(keyPath: "transform")
        
        animation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        
        animation.toValue = NSValue(CATransform3D:
            CATransform3DConcat(//用来合成3D变形动画
                //向上移动10点
                CATransform3DMakeTranslation(0.0, -10.0, 0.0),
                //x,y方向放大150倍，z方向不变
                CATransform3DMakeScale(150.0, 150.0, 1.0)
            )
        )
        animation.duration = animationDuration
        animation.delegate = self
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseIn)
        
        //        同时给遮罩和logo添加变形动画
        toVC.maskLayer.addAnimation(animation, forKey: nil)
        fromVC.logo.addAnimation(animation, forKey: nil)
        //        配置逐渐显现的图层动画
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0.0
        fadeInAnimation.toValue   =  1.0
        fadeInAnimation.duration = animationDuration
        //        给目的视图控制器的视图添加fade-in动画
        toVC.view.layer.addAnimation(fadeInAnimation, forKey: nil)
    }
    func customAnimationPop(transitionContext: UIViewControllerContextTransitioning){
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)! as UIView
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)! as UIView
        
        transitionContext.containerView().insertSubview(toView, belowSubview: fromView)
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            fromView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            fromView.alpha = 0.0
            }, completion: { (finish) -> Void in
                transitionContext.completeTransition(true)
        })
    }
    //    重写animationDidStop()方法，进行动画的结束操作
     func animationEnded(transitionCompleted: Bool) {
//        if let context = storedContext{
//            let zhuceVC = context.viewControllerForKey(UITransitionContextToViewControllerKey)
//            context.containerView()!.addSubview(zhuceVC!.view)
//        }
        storedContext = nil
    }
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        if let context = storedContext{
//            context.completeTransition(!context.transitionWasCancelled())
//            //重置logo
////            let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! LoginviewController
////            fromVC.logo.removeAllAnimations()
//        }
    }
    
}

//
//  JumpAnimationcontroller.swift
//  CATransition
//
//  Created by 红军张 on 16/9/10.
//  Copyright © 2016年 李泽鲁. All rights reserved.
//

import Foundation
import UIKit

enum Animations: Int {
    case Fade = 0                               //淡入淡出
    case Push = 1                               //推挤
    case Reveal = 2                             //揭开
    case MoveIn = 3                             //覆盖
    case Cube = 4                               //立方体
    case SuckEffect = 5                         //吮吸
    case OglFlip = 6                            //翻转
    case RippleEffect = 7                       //波纹
    case PageCurl = 8                           //翻页
    case PageUnCurl = 9                         //反翻页
    case CameraIrisHollowOpen = 10              //开镜头
    case CameraIrisHollowClose = 11             //关镜头
    case CurlDown = 12                          //上翻页
    case CurlUp = 13                            //下翻页
    case FlipFromLeft = 14                      //左翻转
    case FlipFromRight = 15                     //右翻转
}

func specialAnimation(AnimationType: Animations,Direction: String,CurrentVc: UIViewController,ForVc: UIViewController,isJump: Bool) {
    var direction = ""
    switch Direction {
    case "left":
        direction = kCATransitionFromLeft
    case "bottom":
        direction = kCATransitionFromBottom
    case "right":
        direction = kCATransitionFromRight
    case "top":
        direction = kCATransitionFromTop
    default:
        direction = kCATransitionFromLeft
    }
    switch AnimationType {
    case .Fade:
        transitionWithType(kCATransitionFade, WithSubtype: direction,CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .Push:
        transitionWithType(kCATransitionPush, WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .Reveal:
        transitionWithType(kCATransitionReveal, WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .MoveIn:
        transitionWithType(kCATransitionMoveIn, WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .Cube:
        transitionWithType("cube", WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .SuckEffect:
        transitionWithType("suckEffect", WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .OglFlip:
        transitionWithType("oglFlip", WithSubtype: direction,CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .RippleEffect:
        transitionWithType("rippleEffect", WithSubtype: direction,CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .PageCurl:
        transitionWithType("pageCurl", WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .PageUnCurl:
        transitionWithType("pageUnCurl", WithSubtype: direction,CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .CameraIrisHollowOpen:
        transitionWithType("cameraIrisHollowOpen", WithSubtype:direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .CameraIrisHollowClose:
        transitionWithType("cameraIrisHollowClose", WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .CurlDown:
        animationWithView(CurrentVc.view, transition: UIViewAnimationTransition.CurlDown,Forview: ForVc,isjump: isJump)
    case .CurlUp:
        animationWithView(CurrentVc.view, transition: UIViewAnimationTransition.CurlUp,Forview: ForVc,isjump: isJump)
    case .FlipFromLeft:
        animationWithView(CurrentVc.view, transition: UIViewAnimationTransition.FlipFromLeft,Forview: ForVc,isjump: isJump)
    case .FlipFromRight:
        animationWithView(CurrentVc.view, transition: UIViewAnimationTransition.FlipFromRight,Forview: ForVc,isjump: isJump)
    }
}

//MARK:--------CATransition动画实现
func transitionWithType(Jumptype: String,WithSubtype: String,CurrentVC: UIView,ForVC: UIViewController,isjump:Bool) {
    //创建CATransition对象
    let animation = CATransition()
    //设置运动时间
    animation.duration = 0.8
//    animation.speed = 2
    //设置运动type
    animation.type = Jumptype
    if !WithSubtype.isEmpty {
        //设置子类
        animation.subtype = WithSubtype
    }
    //设置运动速度 默认就是线性运动
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    //添加动画
    CurrentVC.layer.addAnimation(animation, forKey: "animation\(arc4random()%100)")
    if isjump {
        UIViewController.showViewController(ForVC, animated: false)
    }
}
//MARK:--------UIView实现动画
func animationWithView(view: UIView,transition: UIViewAnimationTransition,Forview: UIViewController,isjump:Bool) {
    UIView.animateWithDuration(0.7, animations: {
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.setAnimationTransition(transition, forView: view, cache: true)
    }) { (isOK) in
        if isjump {
            UIViewController.showViewController(Forview, animated: false)
        }
    }
}




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
    case fade = 0                               //淡入淡出
    case push = 1                               //推挤
    case reveal = 2                             //揭开
    case moveIn = 3                             //覆盖
    case cube = 4                               //立方体
    case suckEffect = 5                         //吮吸
    case oglFlip = 6                            //翻转
    case rippleEffect = 7                       //波纹
    case pageCurl = 8                           //翻页
    case pageUnCurl = 9                         //反翻页
    case cameraIrisHollowOpen = 10              //开镜头
    case cameraIrisHollowClose = 11             //关镜头
    case curlDown = 12                          //上翻页
    case curlUp = 13                            //下翻页
    case flipFromLeft = 14                      //左翻转
    case flipFromRight = 15                     //右翻转
}

func specialAnimation(_ AnimationType: Animations,Direction: String,CurrentVc: UIViewController,ForVc: UIViewController,isJump: Bool) {
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
    case .fade:
        transitionWithType(kCATransitionFade, WithSubtype: direction,CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .push:
        transitionWithType(kCATransitionPush, WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .reveal:
        transitionWithType(kCATransitionReveal, WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .moveIn:
        transitionWithType(kCATransitionMoveIn, WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .cube:
        transitionWithType("cube", WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .suckEffect:
        transitionWithType("suckEffect", WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .oglFlip:
        transitionWithType("oglFlip", WithSubtype: direction,CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .rippleEffect:
        transitionWithType("rippleEffect", WithSubtype: direction,CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .pageCurl:
        transitionWithType("pageCurl", WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .pageUnCurl:
        transitionWithType("pageUnCurl", WithSubtype: direction,CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .cameraIrisHollowOpen:
        transitionWithType("cameraIrisHollowOpen", WithSubtype:direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .cameraIrisHollowClose:
        transitionWithType("cameraIrisHollowClose", WithSubtype: direction, CurrentVC: CurrentVc.view, ForVC: ForVc,isjump: isJump)
    case .curlDown:
        animationWithView(CurrentVc.view, transition: UIViewAnimationTransition.curlDown,Forview: ForVc,isjump: isJump)
    case .curlUp:
        animationWithView(CurrentVc.view, transition: UIViewAnimationTransition.curlUp,Forview: ForVc,isjump: isJump)
    case .flipFromLeft:
        animationWithView(CurrentVc.view, transition: UIViewAnimationTransition.flipFromLeft,Forview: ForVc,isjump: isJump)
    case .flipFromRight:
        animationWithView(CurrentVc.view, transition: UIViewAnimationTransition.flipFromRight,Forview: ForVc,isjump: isJump)
    }
}

//MARK:--------CATransition动画实现
func transitionWithType(_ Jumptype: String,WithSubtype: String,CurrentVC: UIView,ForVC: UIViewController,isjump:Bool) {
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
    CurrentVC.layer.add(animation, forKey: "animation\(arc4random()%100)")
    if isjump {
        UIViewController.showViewController(ForVC, animated: false)
    }
}
//MARK:--------UIView实现动画
func animationWithView(_ view: UIView,transition: UIViewAnimationTransition,Forview: UIViewController,isjump:Bool) {
    UIView.animate(withDuration: 0.7, animations: {
        UIView.setAnimationCurve(UIViewAnimationCurve.easeOut)
        UIView.setAnimationTransition(transition, for: view, cache: true)
    }, completion: { (isOK) in
        if isjump {
            UIViewController.showViewController(Forview, animated: false)
        }
    }) 
}




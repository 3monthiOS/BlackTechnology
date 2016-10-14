//
//  CommonFuntion.swift
//  App
//
//  Created by 红军张 on 16/9/9.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import Foundation
import UIKit
//MARK: ----- UIcolor 颜色 rgb
func rgba(red: UInt32, _ green: UInt32, _ blue: UInt32, _ alpha: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
}

func rgba(hex: UInt32) -> UIColor {
    return rgba(hex >> 24, hex >> 16 & 0xFF, hex >> 8 & 0xFF, CGFloat(hex & 0xFF) / 255)
}

func rgb(red: UInt32, _ green: UInt32, _ blue: UInt32) -> UIColor {
    return rgba(red, green, blue, 1.0)
}

func rgb(hex: UInt32) -> UIColor {
    return rgba(hex << 8 | 0xFF)
}
/// 延迟执行代码
public func delay(seconds: UInt64, task: () -> Void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), task)
}

/// 异步执行代码块（先非主线程执行，再返回主线程执行）
public func async(backgroundTask: () -> AnyObject!, mainTask: AnyObject? -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        let result = backgroundTask()
        dispatch_sync(dispatch_get_main_queue()) {
            mainTask(result)
        }
    }
}

/// 异步执行代码块（主线程执行）
public func async(mainTask: () -> Void) {
    dispatch_async(dispatch_get_main_queue(), mainTask)
}

/// 顺序执行代码块（在队列中执行）
public func sync(task: () -> Void) {
    dispatch_sync(dispatch_queue_create("com.catorv.LockQueue", nil), task)
}

func alert(message: String, title: String! = nil, completion: (() -> Void)? = nil) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    controller.addAction(UIAlertAction(title: "我知道了", style: .Default) { action in
        controller.dismissViewControllerAnimated(true, completion: nil)
        completion?()
        })
    UIViewController.topViewController?.presentViewController(controller, animated: true, completion: nil)
}

func confirm(message: String, title: String! = nil, completion: Bool -> Void) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    controller.addAction(UIAlertAction(title: "否", style: .Cancel) { action in
        controller.dismissViewControllerAnimated(true, completion: nil)
        completion(false)
        })
    controller.addAction(UIAlertAction(title: "是", style: .Default) { action in
        controller.dismissViewControllerAnimated(true, completion: nil)
        completion(true)
        })
    UIViewController.topViewController?.presentViewController(controller, animated: true, completion: nil)
}

func prompt(message: String, title: String! = nil, text: String! = nil, placeholder: String! = nil, completion: String? -> Void) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    controller.addAction(UIAlertAction(title: "取消", style: .Cancel) { action in
        controller.dismissViewControllerAnimated(true, completion: nil)
        completion(nil)
        })
    controller.addAction(UIAlertAction(title: "确定", style: .Default) { action in
        controller.dismissViewControllerAnimated(true, completion: nil)
        completion(controller.textFields?[0].text ?? "")
        })
    controller.addTextFieldWithConfigurationHandler { textField in
        if let value = text {
            textField.text = value
        }
        if let ph = placeholder {
            textField.placeholder = ph
        }
    }
    UIViewController.topViewController?.presentViewController(controller, animated: true, completion: nil)
}

func toast(message: String, duration: Double = HRToastDefaultDuration, position: AnyObject = HRToastPositionDefault, title: String! = nil, image: UIImage! = nil) {
    if let view = UIApplication.sharedApplication().keyWindow {
        let toastView = view.viewForMessage(message, title: nil, image: image)
        view.showToast(toastView!)
    }
}


//
//  UIViewController+Extension.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

// MARK: Top view controller

extension UIViewController {
    /// 获取当前显示的 View Controller
    public static var topViewController: UIViewController? {
        var vc = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        while true {
            if let nc = vc as? UINavigationController {
                vc = nc.visibleViewController
            } else if let tbc = vc as? UITabBarController {
                if let svc = tbc.selectedViewController {
                    vc = svc
                } else {
                    break
                }
            } else if let pvc = vc?.presentedViewController {
                vc = pvc
            } else {
                break
            }
        }
        
        return vc
    }
}

// MARK: 导航

extension UIViewController {
    /// 显示 view controller（根据当前上下文，自动选择 push 或 present 方式）
    public static func showViewController(controller: UIViewController, animated flag: Bool) {
        let topViewController = UIViewController.topViewController
        if let navigationController = topViewController as? UINavigationController {
            navigationController.pushViewController(controller, animated: flag)
        } else if let navigationController = topViewController?.navigationController {
            navigationController.pushViewController(controller, animated: flag)
        } else {
            topViewController?.presentViewController(controller, animated: flag, completion: nil)
        }
    }
    
    /// 显示 view controller（根据当前上下文，自动选择 push 或 present 方式）
    public func showViewControllerAnimated(animated: Bool) {
        UIViewController.showViewController(self, animated: animated)
    }
    
    /// 关闭 view controller（根据当前上下文，自动选择 pop 或 dismiss 方式）
    public static func closeViewControllerAnimated(animated: Bool) {
        UIViewController.topViewController?.closeViewControllerAnimated(animated)
    }
    
    /// 关闭 view controller（根据当前上下文，自动选择 pop 或 dismiss 方式）
    public func closeViewControllerAnimated(animated: Bool) {
        if let controller = navigationController where controller.viewControllers.count > 1 {
            controller.popViewControllerAnimated(animated)
        } else {
            dismissViewControllerAnimated(animated, completion: nil)
        }
    }
}

// MARK: ------NavigationBar

extension UIViewController {
    
    private struct AssociatedKey {
        static var navigationBarAlpha: CGFloat = 0
    }
    
    var navigationBarAlpha: CGFloat {
        get { return objc_getAssociatedObject(self, &AssociatedKey.navigationBarAlpha) as? CGFloat ?? 1 }
        set { self.setNavigationBarAlpha(newValue, animated: false) }
    }
    
    /// 设置内容透明度
    func setNavigationBarAlpha(alpha: CGFloat, animated: Bool) {
        objc_setAssociatedObject(self, &AssociatedKey.navigationBarAlpha, alpha, .OBJC_ASSOCIATION_RETAIN)
        self.updateNavigationBarAlpha(alpha, animated: animated)
    }
    
    /// 根据内容透明度更新UI效果
    func updateNavigationBarAlpha(alpha: CGFloat? = nil, animated: Bool) {
        guard let navigationBar = self.navigationController?.navigationBar else {return}
        
        if animated == true {
            UIView.beginAnimations(nil, context: nil)
        }
        
        let newAlpha = alpha ?? self.navigationBarAlpha
        
        for subview in navigationBar.subviews {
            let className = String(subview.classForCoder)
            if className == "_UINavigationBarBackground" || className == "UINavigationItemView" {
                subview.alpha = newAlpha
            }
        }
        
        if animated == true {
            UIView.commitAnimations()
        }
    }
    //MARK:---------导航按钮
    enum BarButtonItemPosition {
        case Left, Right,Back
    }
    func createBarButtonItemAtPosition(position: BarButtonItemPosition,Title: String,normalImage: UIImage?, highlightImage: UIImage?, action: Selector?) -> UIBarButtonItem {
        let button = UIButton(type: .Custom)
        var buttonImageEDG: UIEdgeInsets
        var buttonTitleEDG: UIEdgeInsets
        switch position {
        case .Left:
            buttonImageEDG = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 20)
        case .Right:
            buttonImageEDG = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: -13)
        case .Back:
            buttonImageEDG = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 60)
            buttonTitleEDG = UIEdgeInsets(top: 0, left: -45, bottom: 0, right: -15)
            button.titleEdgeInsets = buttonTitleEDG
        }
        button.imageEdgeInsets = buttonImageEDG
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        if let selector = action {
            button.addTarget(self, action: selector, forControlEvents: .TouchUpInside)
        }
        if let image = normalImage {
            button.setImage(image, forState: .Normal)
        }
        if let image = highlightImage {
            button.setImage(image, forState: .Highlighted)
        }
        button.setTitle(Title, forState: .Normal)
        button.setTitleColor(ThemeManager.currentTheme().controlButtonItem, forState: .Normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        switch position {
        case .Left:
            navigationItem.leftBarButtonItem = barButtonItem
        case .Right:
            navigationItem.rightBarButtonItem = barButtonItem
        case .Back:
            navigationItem.backBarButtonItem = barButtonItem
        }
        return barButtonItem
    }
}

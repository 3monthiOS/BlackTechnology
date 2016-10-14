//
//  Theme.swift
//  Pet Finder
//
//  Created by Essan Parto on 5/16/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

enum Theme: Int {
    case Default, Dark, Graphical,whiteColor
    
    var mainColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 210.0/255.0, green: 23.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .whiteColor:
            return UIColor.whiteColor()
        case .Graphical:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        }
    }
    var controlBarTintColor : UIColor{
        switch self {
        case .Default:
            return UIColor(red: 210.0/255.0, green: 23.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        case .Dark:
            return rgb(0xcecece)
        case .Graphical:
            return rgb(0xcecece)
        case .whiteColor:
            return UIColor.whiteColor()
        }
    }
    var controlTintColor : UIColor{
        switch self {
        case .Default:
            return UIColor.whiteColor()
        case .Dark:
            return rgb(0xcecece)
        case .Graphical:
            return rgb(0xcecece)
        case .whiteColor:
            return UIColor(red: 210.0/255.0, green: 23.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        }
    }
    var controlTitleTextAttributes: UIColor{
        switch self {
        case .Default:
            return UIColor.whiteColor()
        case .Dark:
            return rgb(0xcecece)
        case .Graphical:
            return rgb(0xcecece)
        case .whiteColor:
            return UIColor(red: 210.0/255.0, green: 23.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        }
    }
    var controlButtonItem: UIColor{
        switch self {
        case .Default:
            return UIColor.whiteColor()
        case .Dark:
            return rgb(0xcecece)
        case .Graphical:
            return rgb(0xcecece)
        case .whiteColor:
            return UIColor(red: 210.0/255.0, green: 23.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        }
    }

    var greyColor : UIColor {
        switch self {
        case .Default:
            return rgb(0xcecece)
        case .Dark:
            return rgb(0xcecece)
        case .Graphical:
            return rgb(0xcecece)
        case .whiteColor:
            return rgb(0xcecece)
            
        }
    }
    
    var inputBgColor : UIColor {
        switch self {
        case .Default:
            return rgb(0xe6e6e6)
        case .Dark:
            return rgb(0xe6e6e6)
        case .Graphical:
            return rgb(0xe6e6e6)
        case .whiteColor:
            return rgb(0xcecece)
            
        }
    }
    
    var highlightColor : UIColor{
        return mainColor
    }
    
    var bgColor : UIColor {
        return UIColor(red: 210.0/255.0, green: 213.0/255.0, blue: 218.0/255.0, alpha: 1.0)
    }
    
}

let SelectedThemeKey = "SelectedTheme"

struct ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = NSUserDefaults.standardUserDefaults().valueForKey(SelectedThemeKey)?.integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .whiteColor
        }
    }
    
    static func overrideApplyTheme(theme: Theme) {
        //        guard let control = UIViewController.topViewController?.navigationController?.navigationBar else{return} 修改某个当前controller的导航样式
        NSUserDefaults.standardUserDefaults().setValue(theme.rawValue, forKey: SelectedThemeKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        // global tintColor
        let sharedApplication = UIApplication.sharedApplication()
        if theme == .Default{
            sharedApplication.setStatusBarStyle(.LightContent, animated: true)
        }else{
            sharedApplication.setStatusBarStyle(.Default, animated: true)
        }
        sharedApplication.delegate?.window??.tintColor = UIColor(red: 210.0/255.0, green: 23.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        // navbar backgound
        //    UINavigationBar.appearance().backgroundColor = theme.mainColor
        UINavigationBar.appearance().barTintColor = theme.controlBarTintColor
        UINavigationBar.appearance().tintColor = theme.controlTintColor
        
        // navbar title
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: theme.controlTitleTextAttributes]
        //    UINavigationBar.appearance().bar = UIColor.whiteColor()
        UISegmentedControl.appearance().tintColor = UIColor(red: 210.0/255.0, green: 23.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        //button
        //    UIButton.appearance().tintColor = theme.mainColor
        if #available(iOS 9.0, *) {
            UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UINavigationBar.self]).tintColor = theme.controlButtonItem
            
//                    UIButton.appearanceWhenContainedInInstancesOfClasses([UIBarButtonItem.self]).tintColor = UIColor.grayColor()
        } else {
            // Fallback on earlier versions
            UIBarButtonItem.appearanceWhenContainedWithin(UINavigationBar.self).tintColor = theme.controlButtonItem
            
            //        UIButton.appearanceWhenContainedWithin(UIBarButtonItem.self).tintColor = UIColor.grayColor()
        }
    //tabar 下边框
        let rect = CGRectMake(0, 0, App_width, SIZE_1PX);
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, rgb(0xFF5148).CGColor);
        CGContextFillRect(context, rect);
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = img
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        //导航 下边框
        let nav = UINavigationBar.appearance()
        nav.shadowImage = img
        nav.setBackgroundImage(UIImage(named: "bar"), forBarMetrics: UIBarMetrics.Default)
        nav.backgroundColor = UIColor.whiteColor()

    }
}
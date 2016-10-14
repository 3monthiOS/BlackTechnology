//
//  Uiviewcontroller+storyboard.swift
//  App
//
//  Created by 红军张 on 16/9/6.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func loadViewControllerFromStoryboard(storyboardName:String,storyboardID:String) ->UIViewController? {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        return storyboard.instantiateViewControllerWithIdentifier(storyboardID)
    }
    static func loadViewControllerFormNib(nibName:String) -> UIViewController? {
        
        return NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil)!.first as? UIViewController
    }
}

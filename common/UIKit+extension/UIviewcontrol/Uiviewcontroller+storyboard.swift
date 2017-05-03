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
    
    static func loadViewControllerFromStoryboard(_ storyboardName:String,storyboardID:String) ->UIViewController? {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: storyboardID)
    }
    static func loadViewControllerFormNib(_ nibName:String) -> UIViewController? {
        
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)!.first as? UIViewController
    }
}

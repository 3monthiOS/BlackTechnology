//
//  UIView+Swizzle.swift
//  Swiften
//
//  Created by Cator Vee on 5/27/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func __swizzed_init(frame: CGRect) -> UIView {
        let view = self.__swizzed_init(frame: frame)
        view.setupView()
        return view
    }
    
    func __swizzed_init(coder aDecoder: NSCoder) -> UIView? {
        if let view = self.__swizzed_init(coder: aDecoder) {
            view.setupView()
            return view
        }
        return nil
    }
    
    /// 空方法，用于重新设置view的内容
    public func setupView() {
        // nothing
    }
    
    public class func swizzle() {
       
        let _onceToken = NSUUID().uuidString
        // make sure this isn't a subclass
        if self !== UIView.self {
            return
        }
        DispatchQueue.once(token: _onceToken) {
            Swizzler.swizzleMethod(#selector(UIView.init(frame:)), with: #selector(UIView.__swizzed_init(frame:)), forClass: UIView.self)
            Swizzler.swizzleMethod(#selector(UIView.init(coder:)), with: #selector(UIView.__swizzed_init(coder:)), forClass: UIView.self)
        }
        
        
        //   swift 2.3 以前
//        struct Static {
//            static var token = 0;
//        }
//        
//        // make sure this isn't a subclass
//        if self !== UIView.self {
//            return
//        }
//        
//        // 只执行一次
//        dispatch_once(&Static.token) {
//            Swizzler.swizzleMethod(#selector(UIView.init(frame:)), with: #selector(UIView.__swizzed_init(frame:)), forClass: UIView.self)
//            Swizzler.swizzleMethod(#selector(UIView.init(coder:)), with: #selector(UIView.__swizzed_init(coder:)), forClass: UIView.self)
//        }
    }
}

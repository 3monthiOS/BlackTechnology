//
//  KGDrawerAnimator.swift
//  KGDrawerViewController
//
//  Created by Kyle Goddard on 2015-02-10.
//  Copyright (c) 2015 Kyle Goddard. All rights reserved.
//

import UIKit

public class KGDrawerSpringAnimator: NSObject {
    
    let kKGCenterViewDestinationScale:CGFloat = 0.7
    
    public var animationDelay: TimeInterval        = 0.0
    public var animationDuration: TimeInterval     = 0.7
    public var initialSpringVelocity: CGFloat        = 9.8 // 9.1 m/s == earth gravity accel.
    public var springDamping: CGFloat                = 0.8
    
    // TODO: can swift have private functions in a protocol?
    func applyTransforms(side: KGDrawerSide, drawerView: UIView, centerView: UIView) {
        
        let direction = side.rawValue
        let sideWidth = drawerView.bounds.width
        let centerWidth = centerView.bounds.width
        let centerHorizontalOffset = direction * sideWidth
        let scaledCenterViewHorizontalOffset = direction * (sideWidth - (centerWidth - kKGCenterViewDestinationScale * centerWidth) / 2.0)
        
        let sideTransform = CGAffineTransform(translationX: centerHorizontalOffset, y: 0.0)
        drawerView.transform = sideTransform
        
        let centerTranslate = CGAffineTransform(translationX: scaledCenterViewHorizontalOffset, y: 0.0)
        let centerScale = CGAffineTransform(scaleX: kKGCenterViewDestinationScale, y: kKGCenterViewDestinationScale)
        centerView.transform = centerScale.concatenating(centerTranslate)
        
    }
    
    func resetTransforms(views: [UIView]) {
        for view in views {
            view.transform = CGAffineTransform.identity
        }
    }

}

extension KGDrawerSpringAnimator: KGDrawerAnimating {

    func dismissDrawer(side: KGDrawerSide, drawerView: UIView, centerView: UIView, animated: Bool, complete: @escaping (Bool) -> Void) {
        if (animated) {
            UIView.animate(withDuration: animationDuration,
                           delay: animationDelay,
                           usingSpringWithDamping: springDamping,
                           initialSpringVelocity: initialSpringVelocity,
                           options: UIViewAnimationOptions.curveLinear,
                           animations: {
                            self.resetTransforms(views: [drawerView, centerView])
            }, completion: complete)
        } else {
            self.resetTransforms(views: [drawerView, centerView])
        }
    }
    
    func openDrawer(side: KGDrawerSide, drawerView: UIView, centerView: UIView, animated: Bool, complete: @escaping (Bool) -> Void) {
        if (animated) {
            UIView.animate(withDuration: animationDuration,
                           delay: animationDelay,
                           usingSpringWithDamping: springDamping,
                           initialSpringVelocity: initialSpringVelocity,
                           options: UIViewAnimationOptions.curveLinear,
                           animations: {
                            self.applyTransforms(side: side, drawerView: drawerView, centerView: centerView)
                            
            }, completion: complete)
        } else {
            self.applyTransforms(side: side, drawerView: drawerView, centerView: centerView)
        }
    }
    
    
    func willRotateWithDrawerOpen(side: KGDrawerSide, drawerView: UIView, centerView: UIView) {
        
    }
    
    func didRotateWithDrawerOpen(side: KGDrawerSide, drawerView: UIView, centerView: UIView) {
        UIView.animate(withDuration: animationDuration,
                       delay: animationDelay,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: UIViewAnimationOptions.curveLinear,
                       animations: {}, completion: nil )
    }
    
}

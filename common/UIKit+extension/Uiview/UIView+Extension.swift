//
//  UIView+Extension.swift
//  App
//
//  Created by 红军张 on 2017/5/23.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation

extension UIView {
    
    func animateCircular(withDuration duration: TimeInterval, center: CGPoint, revert: Bool = false, animations: () -> Void, completion: ((Bool) -> Void)? = nil) {
//        let snapshot = snapshotView(afterScreenUpdates: false)!
//        snapshot.frame = bounds
//        self.addSubview(snapshot)
//        
//        let center = convert(center, to: snapshot)
//        let radius: CGFloat = {
//            let x = max(center.x, frame.width - center.x)
//            let y = max(center.y, frame.height - center.y)
//            return sqrt(x * x + y * y)
//        }()
//        var animation : CircularRevealAnimator
//        if !revert {
//            animation = CircularRevealAnimator(layer: snapshot.layer, center: center, startRadius: 0, endRadius: radius, invert: true)
//        } else {
//            animation = CircularRevealAnimator(layer: snapshot.layer, center: center, startRadius: radius, endRadius: 0, invert: false)
//        }
//        animation.duration = duration
//        animation.completion = {
//            snapshot.removeFromSuperview()
//            completion?(true)
//        }
//        animation.start()
//        animations()
    }
}

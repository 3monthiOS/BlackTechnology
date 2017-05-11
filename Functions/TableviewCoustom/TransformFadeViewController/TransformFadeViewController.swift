//
//  TransformFadeViewController.swift
//  App
//
//  Created by 红军张 on 2017/5/8.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
private enum EType : Int {
    
    case typeOne, typeTwo
}

class TransformFadeViewController: CustomFullContentViewController {
    
    fileprivate var images              : [UIImage]!
    fileprivate var tranformFadeViewOne : TranformFadeView!
    fileprivate var tranformFadeViewTwo : TranformFadeView!
    fileprivate var timer               : Timer!
    fileprivate var type                : EType = .typeOne
    fileprivate var count               : Int   = 0
    
    override func buildTitleView() {
        self.title = "图片碎片化mask动画"
        super.buildTitleView()
    }
    
    override func setup() {
        
        super.setup()
        
        self.contentView?.frame = CGRect(x: 0, y: 0, width: App_width, height: App_height)
        images = [UIImage]()
        images.append(UIImage(named: "1")!)
        images.append(UIImage(named: "3")!)
        images.append(UIImage(named: "4")!)
        images.append(UIImage(named: "2")!)
        images.append(UIImage(named: "13")!)
        
        tranformFadeViewOne                      = TranformFadeView(frame: contentView!.bounds, verticalCount: 3, horizontalCount: 12,
                                                                    fadeDuradtion: 1, animationGapDuration: 0.075)
        tranformFadeViewOne.imageContentMode     = .scaleAspectFill
        tranformFadeViewOne.image                = currentImage()
        tranformFadeViewOne.start(animated: false, transformTo: .show)
        contentView!.addSubview(tranformFadeViewOne)
        
        tranformFadeViewTwo                      = TranformFadeView(frame: contentView!.bounds, verticalCount: 3, horizontalCount: 12,
                                                                    fadeDuradtion: 1, animationGapDuration: 0.075)
        tranformFadeViewTwo.imageContentMode     = .scaleAspectFill
        tranformFadeViewTwo.image                = currentImage()
        tranformFadeViewTwo.start(animated: false, transformTo: .fade)
        contentView!.addSubview(tranformFadeViewTwo)
        
        timerEvent()
        
        // Init timer.
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(TransformFadeViewController.timerEvent), userInfo: nil, repeats: true)
    }
    
    func timerEvent() {
        
        if type == .typeOne {
            
            type = .typeTwo
            contentView?.sendSubview(toBack: tranformFadeViewTwo)
            tranformFadeViewTwo.image = currentImage()
            tranformFadeViewTwo.start(animated: false, transformTo: .show)
            tranformFadeViewOne.start(animated: true,  transformTo: .fade)
            
        } else {
            
            type = .typeOne
            contentView?.sendSubview(toBack: tranformFadeViewOne)
            tranformFadeViewOne.image = currentImage()
            tranformFadeViewOne.start(animated: false, transformTo: .show)
            tranformFadeViewTwo.start(animated: true,  transformTo: .fade)
        }
    }
    
    fileprivate func currentImage() -> UIImage {
        
        count = (count + 1) % images.count
        return images[count]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
}

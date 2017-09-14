//
//  ZHJRunningLight.swift
//  App
//
//  Created by 红军张 on 2017/9/14.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation

class ZHJRunningLight: UIScrollView {
    
    var text: String?
    var font: UIFont?
    var bgColor: UIColor?
    var textColor: UIColor?
    var slidingSpeed: CGFloat?
    var displayLink: CADisplayLink?
    var zhjSize: CGSize?
    var labelSize: CGSize?
    var isPaused: Bool = true
    
    init(frame: CGRect,color: UIColor,bgColor: UIColor) {
        super.init(frame: frame)
        zhjSize = frame.size
        self.textColor = color
        self.bgColor = bgColor
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    /**
     控件布局
     */
    func addTxtLabel() {
        guard let zhjSize = self.zhjSize,let labelSize = self.labelSize else {return}
        removeAllSubViews()
        for i in 0..<3 {
            let x = isPaused ? 0 : i == 2 ? (labelSize.width + zhjSize.width) : CGFloat(CGFloat(i) * labelSize.width + zhjSize.width/2)
            let y = 0
            let w = isPaused ? zhjSize.width : i == 1 ? zhjSize.width/2 : labelSize.width
            let h = zhjSize.height
            
            let label = UILabel(frame: CGRect(x: x, y: CGFloat(y), width: w, height: h))
            label.text = self.text
            label.textAlignment = .center
            if i == 1{
                label.textColor = UIColor.clear
            } else {
                label.textColor = self.textColor
            }
            label.font = self.font
            label.backgroundColor = UIColor.clear
            addSubview(label)
        }
    }
    /**
     设置控件值
     
     @param text 显示文字
     @param font 字体
     */
    func zhj_setTextAndFont(text: String,font: UIFont = UIFont.systemFont(ofSize: 15.0)) {
//        self.slidingSpeed = 1 ?? 1
        self.text = text
        self.font = font
        self.labelSize = text.WithStrigFontSize(font, sizeFont: nil, width: nil)
        
        var labelSizeFrame: CGSize = self.labelSize!
        labelSizeFrame.width = labelSizeFrame.width + 6;
        self.labelSize = labelSizeFrame
        
        guard let zhjSize = self.zhjSize,let labelSize = self.labelSize else {alert("请给控件大小赋值");return}
        
        var selfFrame: CGRect = frame
        selfFrame.size.height = zhjSize.height > labelSize.height ? zhjSize.height : labelSize.height
        self.frame = selfFrame;
        
        (zhjSize.width >= labelSize.width) ? (isPaused = true) : (isPaused = false)
        
        addTxtLabel()
        
        self.contentSize = CGSize(width: isPaused ? zhjSize.width : labelSize.width*2 + zhjSize.width, height: selfFrame.size.height)
        
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(zhj_scrollingLabelAction))
            displayLink?.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
        }
        
        if (isPaused) {
            displayLink?.isPaused = true
        } else {
            displayLink?.isPaused = false
        }
    }
    
    func zhj_scrollingLabelAction() {
        var point: CGPoint = self.contentOffset
        if (point.x < labelSize!.width + zhjSize!.width/2) {
            point.x += slidingSpeed ?? 1
        }else{
            point.x = 1;
        }
        self.contentOffset = point;
    }
    
    /**
     开启暂停滚动
     
     @param paused 滚动状态
     */
    func zhj_setPaused(ispaus: Bool) {
        displayLink?.isPaused = ispaus
    }
    
    deinit {
        displayLink?.invalidate()
        displayLink?.remove(from: .current, forMode: .defaultRunLoopMode)
    }
}

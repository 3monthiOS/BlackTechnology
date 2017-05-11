//
//  LTDemoViewController.swift
//  App
//
//  Created by 红军张 on 2017/5/9.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import LTMorphingLabel

class LTDemoViewController : UIViewController, LTMorphingLabelDelegate {
    
    fileprivate var i = -1
    fileprivate var textArray = [
        "What is design?",
        "Design", "Design is not just", "what it looks like", "and feels like.",
        "Design", "is how it works.", "- Steve Jobs",
        "Older people", "sit down and ask,", "'What is it?'",
        "but the boy asks,", "'What can I do with it?'.", "- Steve Jobs",
        "", "Swift", "Objective-C", "iPhone", "iPad", "Mac Mini",
        "MacBook Pro🔥", "Mac Pro⚡️",
        "爱老婆",
        "老婆和女儿"
    ]
    fileprivate var isDay = false
    
    fileprivate var text: String {
        i = i >= textArray.count - 1 ? 0 : i + 1
        return textArray[i]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.delegate = self
    }
    
    @IBOutlet fileprivate var label: LTMorphingLabel!
    
    @IBAction func changeText(_ sender: AnyObject) {
        label.text = text
    }
    
    @IBAction func btnsClick(_ sender: Any) {
        let seg = sender as? UIButton
        if let effect = LTMorphingEffect(rawValue: (seg?.tag)!) {
            label.morphingEffect = effect
            changeText(sender as AnyObject)
        }
    }
    
    
    @IBAction func nightorday(_ sender: Any) {
        let isNight = isDay
        view.backgroundColor = isNight ? UIColor.black : UIColor.white
        label.textColor = isNight ? UIColor.white : UIColor.black
        isDay = !isDay
    }
    
    
    @IBAction func changeFontSize(_ sender: UISlider) {
        label.font = UIFont.init(name: label.font.fontName, size: CGFloat(sender.value))
        label.text = label.text
    }
}

extension LTDemoViewController {
    
    func morphingDidStart(_ label: LTMorphingLabel) {
        
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        
    }
    
    func morphingOnProgress(_ label: LTMorphingLabel, progress: Float) {
        
    }
    
}

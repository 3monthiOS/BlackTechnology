//
//  RadiationTransformationController.swift
//  App
//
//  Created by 红军张 on 2017/5/17.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class RadiationTransformationController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet var leftAndRightSlider: UISlider!
    @IBOutlet var upAndDownSlider: UISlider!
    @IBOutlet var xScaleSlider: UISlider!
    @IBOutlet var yScalerSlider: UISlider!
    @IBOutlet var rotationSlider: UISlider!
    var isok = false
    override func viewDidLoad(){
        super.viewDidLoad()
        self.title = "放射变换"
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 1
        image.layer.cornerRadius = image.frame.size.width/2
        congfigSlider()
    }
    func congfigSlider() {
        leftAndRightSlider.minimumValue = -Float(image.width)
        leftAndRightSlider.maximumValue = Float(image.width)
        leftAndRightSlider.value = 0
        
        upAndDownSlider.minimumValue = -Float(image.height)
        upAndDownSlider.maximumValue = Float(image.height)
        upAndDownSlider.value = 0
        
        xScaleSlider.minimumValue = -Float(1)
        xScaleSlider.maximumValue = Float(1)
        xScaleSlider.value = 1
        
        yScalerSlider.minimumValue = -Float(1)
        yScalerSlider.maximumValue = Float(1)
        yScalerSlider.value = 1
        
        rotationSlider.minimumValue = -Float(2 * Double.pi)
        rotationSlider.maximumValue = Float(2 * Double.pi)
        rotationSlider.value = 0
    }
    
    @IBAction func changeLeftOrRightSlider(_ sender: UISlider) {
        if yScalerSlider.value < 0 && !isok {
            isok = true
            image.image = UIImage(named: "cat")
            
        } else if (yScalerSlider.value > 0 && isok) {
            isok = false
            image.image = UIImage(named: "分享缩略图")
        }
        print(yScalerSlider.value)
        var transform = CGAffineTransform.identity
        
        //平移
        transform = transform.translatedBy(x: CGFloat(leftAndRightSlider.value),
                                           y: CGFloat(-upAndDownSlider.value))
        //缩放
        transform = transform.scaledBy(x: CGFloat(xScaleSlider.value),
                                       y: CGFloat(yScalerSlider.value))
        //旋转
        transform = transform.rotated(by: CGFloat(rotationSlider.value))
        
        image.transform = transform
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  GradientViewController.swift
//  App
//
//  Created by XiuXiu on 9/23/16.
//  Copyright © 2016 IndependentRegiment. All rights reserved.
//

import UIKit

class GradientViewController: UIViewController {

  @IBOutlet weak var baseView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

      baseView.addGradientBackgroundColorWith(UIColor.whiteColor(), middleColor: UIColor.blackColor())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
  @IBAction func positionChangeClick(sender: UISlider) {
     let gradient = baseView.layer.sublayers?.first as? CAGradientLayer
    gradient?.locations = [0,sender.value ,1]
  }

  @IBAction func colorChangeClick(sender: UISlider) {
    let gradient = baseView.layer.sublayers?.first as? CAGradientLayer
    let value = UInt32(sender.value)
    let color = rgb(value, value * value,value)
//    UIColor(red: CGFloat(sender.value), green: CGFloat(sender.value * sender.value), blue: CGFloat(sender.value), alpha: 1.0)
    gradient?.colors = [UIColor.whiteColor().CGColor,color.CGColor,UIColor.whiteColor().CGColor]
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

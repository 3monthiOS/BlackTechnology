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

      baseView.addGradientBackgroundColorWith(UIColor.white, middleColor: UIColor.black)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
  @IBAction func positionChangeClick(_ sender: UISlider) {
     let gradient = baseView.layer.sublayers?.first as? CAGradientLayer
    gradient?.locations = [0,sender.value ,1]
  }

  @IBAction func colorChangeClick(_ sender: UISlider) {
    let gradient = baseView.layer.sublayers?.first as? CAGradientLayer
    let value = UInt32(sender.value)
    let color = rgb(value, value * value,value)
//    UIColor(red: CGFloat(sender.value), green: CGFloat(sender.value * sender.value), blue: CGFloat(sender.value), alpha: 1.0)
    gradient?.colors = [UIColor.white.cgColor,color.cgColor,UIColor.white.cgColor]
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

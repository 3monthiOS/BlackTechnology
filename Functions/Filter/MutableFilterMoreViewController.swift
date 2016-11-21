//
//  MutableFilterMoreViewController.swift
//  App
//
//  Created by XiuXiu on 9/30/16.
//  Copyright © 2016 IndependentRegiment. All rights reserved.
//

import UIKit

class MutableFilterMoreViewController: UIViewController {

  @IBOutlet weak var upImgView: UIImageView!
  @IBOutlet weak var downImgView: UIImageView!
  
  lazy var originalImage: UIImage = {
    return UIImage(named: "green_beauty.jpg")!
  }()
  lazy var context: CIContext = {
    return CIContext(options: nil)
  }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      upImgView.image = originalImage
      
    }

  @IBAction func originalImgClick(sender: UIButton) {
    upImgView.image = originalImage
    
  }
  @IBAction func useFilterClick(sender: UIButton) {
    debugPrint("test git push without ssh")
//    let cubeMap = creat(UnsafePointer(bitPattern: 60), 90)

////    let cubeMap = createCubeMap(60,90)
//    let data = NSData(bytes: UnsafePointer(nilLiteral:(cubeMap)), length:Int(cubeMap.length))
//    let data = NSData(bytes: UnsafePointer(cubeMap), length: Int(cubeMap.length),free(UnsafeMutablePointer())
//
//    let data = NSData(bytesNoCopy: cubeMap.data, length: Int(cubeMap.length), freeWhenDone: true)
//    
//    let colorCubeFilter = CIFilter(name: "CIColorCube")
//    
//    
//    
//    colorCubeFilter.setValue(cubeMap.dimension, forKey: "inputCubeDimension")
//    
//    colorCubeFilter.setValue(data, forKey: "inputCubeData")
//    
//    colorCubeFilter!.setValue(CIImage(image: upImgView.image!), forKey: kCIInputImageKey)
//    
//    var outputImage = colorCubeFilter!.outputImage
//    
//    
//    
//    let sourceOverCompositingFilter = CIFilter(name: "CISourceOverCompositing")
//    
//    sourceOverCompositingFilter!.setValue(outputImage, forKey: kCIInputImageKey)
//    
//    sourceOverCompositingFilter!.setValue(CIImage(image: UIImage(named: "background")!), forKey: kCIInputBackgroundImageKey)
//    
//    
//    outputImage = sourceOverCompositingFilter!.outputImage
//    
//    let cgImage = context.createCGImage(outputImage!, fromRect: outputImage!.extent)
//    
//    downImgView.image = UIImage(CGImage: cgImage!)
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
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

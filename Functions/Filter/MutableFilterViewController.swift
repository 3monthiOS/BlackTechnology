//
//  MutableFilterViewController.swift
//  App
//
//  Created by XiuXiu on 9/24/16.
//  Copyright © 2016 IndependentRegiment. All rights reserved.
//

import UIKit

class MutableFilterViewController: UIViewController {

  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var baseImgView: UIImageView!
  
  lazy var originalImage: UIImage = {
    return UIImage(named: "xiong.png")!
  }()
  lazy var context: CIContext = {
    return CIContext(options: nil)
  }()
  var filter: CIFilter!
    override func viewDidLoad() {
        super.viewDidLoad()

       configureImgView()
      configureSlider()
    }
  fileprivate func configureImgView(){
    baseImgView.layer.shadowOpacity = 0.8
    baseImgView.layer.shadowColor = UIColor.black.cgColor
    baseImgView.layer.shadowOffset = CGSize(width: 1, height: 1)
    baseImgView.image = originalImage
  }
  fileprivate func configureSlider(){
    slider.maximumValue = Float(M_PI)
    slider.minimumValue = Float(-M_PI)
    slider.value = 0
    
    let inputImage = CIImage(image: originalImage)
    filter = CIFilter(name: "CIHueAdjust")
    filter.setValue(inputImage, forKey: kCIInputImageKey)
    slider.sendActions(for: UIControlEvents.valueChanged)
  }
  func showFiltersInConsole() {
    
    let filterNames = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
//    filters = filterNames.filter({$0.containsString("Photo") || $0.containsString("Color") })
//    filters.append("CIGaussianBlur")
    print(filterNames.count)
    
    print(filterNames)
    
  }
  @IBAction func changeFilterParmClick(_ sender: UISlider) {
    filter.setValue(slider.value, forKey: kCIInputAngleKey)
    let outputImage = filter.outputImage
    let cgImage = context.createCGImage(outputImage!, from: outputImage!.extent)
    baseImgView.image = UIImage(cgImage: cgImage!)
  }
  
  @IBAction func oldFilmStyleClick(_ sender: UIButton) {
    let inputImage = CIImage(image: originalImage)
    
    // 1.创建CISepiaTone滤镜
    let sepiaToneFilter = CIFilter(name: "CISepiaTone")
    sepiaToneFilter!.setValue(inputImage, forKey: kCIInputImageKey)
    sepiaToneFilter!.setValue(1, forKey: kCIInputIntensityKey) // Intensity  强度；强烈；[电子] 亮度；紧张

    // 2.创建白斑图滤镜
    let whiteSpecksFilter = CIFilter(name: "CIColorMatrix") //  Matrix  n. [数] 矩阵；模型；[生物][地质] 基质；母体；子宫；[地质] 脉石
    whiteSpecksFilter!.setValue(CIFilter(name: "CIRandomGenerator")!.outputImage!.cropping(to: inputImage!.extent), forKey: kCIInputImageKey)
    whiteSpecksFilter!.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputRVector")
    whiteSpecksFilter!.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputGVector")
    whiteSpecksFilter!.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputBVector")
    whiteSpecksFilter!.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBiasVector")
    
    // 3.把CISepiaTone滤镜和白斑图滤镜以源覆盖(source over)的方式先组合起来
    let sourceOverCompositingFilter = CIFilter(name: "CISourceOverCompositing") // Compositing vt. 使合成；使混合（composite的ing形式）  n. 影像合成
    sourceOverCompositingFilter!.setValue(whiteSpecksFilter!.outputImage, forKey: kCIInputBackgroundImageKey)
    sourceOverCompositingFilter!.setValue(sepiaToneFilter!.outputImage, forKey: kCIInputImageKey)
    
    // ---------上面算是完成了一半
    
    // 4.用CIAffineTransform滤镜先对随机噪点图进行处理
    let affineTransformFilter = CIFilter(name: "CIAffineTransform")
    affineTransformFilter!.setValue(CIFilter(name: "CIRandomGenerator")!.outputImage!.cropping(to: inputImage!.extent), forKey: kCIInputImageKey)
      affineTransformFilter!.setValue(NSValue(cgAffineTransform: CGAffineTransform(scaleX: 1.5, y: 25)), forKey: kCIInputTransformKey)
    
    // 5.创建蓝绿色磨砂图滤镜
    let darkScratchesFilter = CIFilter(name: "CIColorMatrix")
    darkScratchesFilter!.setValue(affineTransformFilter!.outputImage, forKey: kCIInputImageKey)
    darkScratchesFilter!.setValue(CIVector(x: 4, y: 0, z: 0, w: 0), forKey: "inputRVector")
    darkScratchesFilter!.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputGVector")
    darkScratchesFilter!.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBVector")
    darkScratchesFilter!.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputAVector")
    darkScratchesFilter!.setValue(CIVector(x: 0, y: 1, z: 1, w: 1), forKey: "inputBiasVector")
    
    // 6.用CIMinimumComponent滤镜把蓝绿色磨砂图滤镜处理成黑色磨砂图滤镜
    let minimumComponentFilter = CIFilter(name: "CIMinimumComponent")
    minimumComponentFilter!.setValue(darkScratchesFilter!.outputImage, forKey: kCIInputImageKey)
    
    // ---------上面算是基本完成了
    
    // 7.最终组合在一起
    let multiplyCompositingFilter = CIFilter(name: "CIMultiplyCompositing")
    multiplyCompositingFilter!.setValue(minimumComponentFilter!.outputImage, forKey: kCIInputBackgroundImageKey)
    multiplyCompositingFilter!.setValue(sourceOverCompositingFilter!.outputImage, forKey: kCIInputImageKey)
    
    // 8.最后输出
    let outputImage = multiplyCompositingFilter!.outputImage
    let cgImage = context.createCGImage(outputImage!, from: outputImage!.extent)
    baseImgView.image = UIImage(cgImage: cgImage!)
  }
  
  @IBAction func InvertColorStyleClick(_ sender: UIButton) {
    let colorInvertFilter = CIColorInvert()
    colorInvertFilter.inputImage = CIImage(image: baseImgView.image!)
    let outputImage = colorInvertFilter.outputImage
    let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
    baseImgView.image = UIImage(cgImage: cgImage!)
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

class CIColorInvert: CIFilter {
  
  var inputImage: CIImage!

  override var outputImage: CIImage! {
    get {
      return CIFilter(name: "CIColorMatrix", withInputParameters: [
        kCIInputImageKey : inputImage,
        "inputRVector" : CIVector(x: -1, y: 0, z: 0),
        "inputGVector" : CIVector(x: 0, y: -1, z: 0),
        "inputBVector" : CIVector(x: 0, y: 0, z: -1),
        "inputBiasVector" : CIVector(x: 1, y: 1, z: 1),
        ])!.outputImage
    }
  }
}



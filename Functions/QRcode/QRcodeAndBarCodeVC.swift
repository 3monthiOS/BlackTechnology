//
//  QRcodeAndBarCodeVC.swift
//  App
//
//  Created by XiuXiu on 2017/6/26.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import CoreImage
class QRcodeAndBarCodeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      title = "二维码和条形码"
view.backgroundColor = UIColor.white
      let QRcodeImage = UIImageView(frame: CGRect(x: 0.0,y:120,width: 200,height: 200))
      QRcodeImage.image = QRcode()
      view.addSubview(QRcodeImage)
      let barCodeImage = UIImageView(frame: CGRect(x: 10.0,y:350,width: view.bounds.width - 20,height: 80))
       barCodeImage.image = barCode()
      view.addSubview(barCodeImage)
    }
  func QRcode()-> UIImage {
    let  ciimg = generateQRCodeImage("www.baidu.com")
    return resizeCode(image: ciimg,size: CGSize(width: 200, height: 200))
  }
  func barCode()-> UIImage {
    let  ciimg = generateBarCodeImage("122333434")
    return resizeCode(image: ciimg,size: CGSize(width: view.bounds.width - 20, height: 80))
  }
  
  func generateQRCodeImage(_ code: String)-> CIImage {
    let data = code.data(using: String.Encoding.utf8)
    let filter: CIFilter? = CIFilter(name: "CIQRCodeGenerator")
    filter?.setValue(data, forKey: "inputMessage")
    filter?.setValue("Q", forKey: "inputCorrectionLevel")
    return filter!.outputImage!
  }
  
  func generateBarCodeImage(_ code: String) -> CIImage {
    let data = code.data(using: String.Encoding.ascii)
    let filter: CIFilter? = CIFilter(name: "CICode128BarcodeGenerator")
    filter?.setValue(data, forKey: "inputMessage")
    // 设置生成的条形码的上，下，左，右的margins的值
    filter?.setValue(0, forKey: "inputQuietSpace")
    return filter!.outputImage!
  }
  
  func resizeCode(image: CIImage , size: CGSize)-> UIImage {
    let extent = image.extent
    let scaleWidth: CGFloat = size.width / extent.width
    let scaleHeight: CGFloat = size.height / extent.height
    let width: size_t = size_t(extent.width * scaleWidth)
    let height: size_t = size_t(extent.height * scaleHeight)
    // 拿到 CIContext 将 CIImage 转化成CGImage
    let content: CIContext  = CIContext()
    let imageRef: CGImage = content.createCGImage(image, from: extent)!
    //  拿到 CGContext  将 CGImage 尺寸绘制成 需要尺寸
    let colorSpaceRef: CGColorSpace = CGColorSpaceCreateDeviceGray()
    let contentRef: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpaceRef, bitmapInfo: CGImageAlphaInfo.none.rawValue)!
    contentRef.interpolationQuality = .none
    contentRef.scaleBy(x: scaleWidth, y: scaleHeight)
    contentRef.draw(imageRef, in: extent)
    let imageRefResized: CGImage = contentRef.makeImage()!
    // 将 CGImage 转化成 UIImage
    return UIImage(cgImage: imageRefResized)
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

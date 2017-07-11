//
//  ProduceViewController.swift
//  QRCodeTest
//
//  Created by kunpo on 2017/6/27.
//  Copyright © 2017年 kemp. All rights reserved.
//

import Foundation
import UIKit


class ProduceViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var QRCodeTypeSeg: UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
}

extension ProduceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text?.characters.count == 0 {
            return true
        }
        
        let type = seg.selectedSegmentIndex
        if type == 0 {
            produceQRCode(text: textField.text!)
        } else {

//            if let num = Double(textField.text!) {
                let image = ProduceBarCodeManager.producBarCode(number: textField.text!, imageSize: CGSize(width: 150, height: 150))
                imageView.image = image
//            } else {
//                imageView.image = nil
//            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func produceQRCode(text: String) {
        
        switch QRCodeTypeSeg.selectedSegmentIndex {
        case 0:
            //普通的二维码
            let image = ProduceQRCodeManager.produceQRCode(data: text, imageWidth: 150)
            imageView.image = image
        case 1:
            //彩色的二维码
            let image = ProduceQRCodeManager.producQRCode(data: text, backgroundColor: UIColor.red, mainColor: UIColor.white, imageSize: CGSize(width: 150.0, height: 150.0))
            imageView.image = image
        case 2:
            //带logo的二维码 
            guard let logoImage = UIImage(named: "image") else {
                print("获取logoImage出错")
                return
            }
            let image = ProduceQRCodeManager.produceQRCode(data: text, imageWidth: 150, logoImage: logoImage, logoScale: 0.3)
            imageView.image = image
        default:
            imageView.image = nil
        }
    }
    
    
    
}

class ProduceQRCodeManager: NSObject {
    
    //生成普通的二维码
    static func produceQRCode(data: String, imageWidth: CGFloat) -> UIImage? {
        // 1、创建滤镜对象
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //设置滤镜默认属性
        filter?.setDefaults()
        //2、设置数据，将字符串转换为data
        let infoData = data.data(using: String.Encoding.utf8)
        //通过kvc设置路径inputMessage数据
        filter?.setValue(infoData, forKeyPath: "inputMessage")
//        [filter setValue:"H" forKey:@"inputCorrectionLevel"];
        /*
         inputCorrectionLevel
         用于定义生成二维码对象的容错率。QRCode有容错能力，QRCode被破坏，仍然有可能被机器读取内容。范围在7% ~ 30%。容错率越高、QRCode图像面积越大。
         L:7%,M:15%,Q:25%,H:30%
         */
        if let ciImage = filter?.outputImage {
            let size = CGSize(width: imageWidth, height: imageWidth)
            return UIImage.trunImageFrom(ciImage: ciImage, imageSize: size)
        }
        return nil
    }
    
    //生成带logo的二维码
    /**logoScale logo占图片的比例 0 - 0.5  */
    static func produceQRCode(data: String, imageWidth: CGFloat, logoImage: UIImage, logoScale: CGFloat) -> UIImage? {
        
        
        let scale = logoScale > 0.5 ? 0.5 : logoScale
        
        
        //获取普通的二维码图片
        let image = produceQRCode(data: data, imageWidth: imageWidth)
        // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
        // 开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
        UIGraphicsBeginImageContextWithOptions((image?.size)!, false, UIScreen.main.scale)
        // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
        let drawRect = CGRect(origin: CGPoint.zero, size: image!.size)
        image?.draw(in: drawRect)
        //把logo画上去，怎么给logo添加圆角和边框呢??????
        let logoW = drawRect.size.width * scale
        let logoH = drawRect.size.height * scale
        let logoX = (drawRect.size.width - logoW) * 0.5
        let logoY = (drawRect.size.height - logoH) * 0.5
        
        
        logoImage.draw(in: CGRect(x: logoX, y: logoY, width: logoW, height: logoH))
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        return finalImage
    }
    
    //生成彩色的二维码
    static func producQRCode(data: String, backgroundColor: UIColor, mainColor: UIColor, imageSize: CGSize) -> UIImage? {
        // 1、创建滤镜对象
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //设置滤镜默认属性
        filter?.setDefaults()
        //2、设置数据，将字符串转换为data
        let infoData = data.data(using: String.Encoding.utf8)
        //3、通过kvc设置路径inputMessage数据
        filter?.setValue(infoData, forKeyPath: "inputMessage")
        //4、获取滤镜输出的图片
        guard let ciImage = filter?.outputImage else {
            return nil
        }
        //5、创建彩色过滤器
        let colorFilter = CIFilter(name: "CIFalseColor")
        //6、设置
        colorFilter?.setDefaults()
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        
        colorFilter?.setValue(CIColor(color: backgroundColor), forKey: "inputColor0")
        colorFilter?.setValue(CIColor(color: mainColor), forKey: "inputColor1")
        
        
        
        //7、获取输出
        guard let colorCiImage = colorFilter?.outputImage else {
            return nil
        }
        //8、转化为UIImage,转化造成了二维码颜色改变了????????
//        return UIImage.trunImageFrom(ciImage: colorCiImage, imageSize: imageSize)
        return UIImage(ciImage: colorCiImage)
    }
    
    
}

class ProduceBarCodeManager: NSObject {
    
    static func producBarCode(number: String, imageSize: CGSize) -> UIImage? {
            //😂这里用的最终还是字符串
        let data = number.data(using: String.Encoding.ascii)
        let filter: CIFilter? = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        // 设置生成的条形码的上，下，左，右的margins的值
        filter?.setValue(0, forKey: "inputQuietSpace")
        /*
         inputQuietSpace 对条形码的每一侧加入空白的像素数。默认值是7.0，最大值是20.0，最小值是0.0.
         */
        if let ciImage = filter?.outputImage {
            return UIImage.trunImageFrom(ciImage: ciImage, imageSize: imageSize)
        }
        return nil
    }
}

extension UIImage {
    
    static func trunImageFrom(ciImage: CIImage, imageSize: CGSize) -> UIImage {
        let extent = ciImage.extent
        let scaleWidth: CGFloat = imageSize.width / extent.width
        let scaleHeight: CGFloat = imageSize.height / extent.height
        let width: size_t = size_t(extent.width * scaleWidth)
        let height: size_t = size_t(extent.height * scaleHeight)
        // 拿到 CIContext 将 CIImage 转化成CGImage
        let content: CIContext  = CIContext()
        let imageRef: CGImage = content.createCGImage(ciImage, from: extent)!
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
}



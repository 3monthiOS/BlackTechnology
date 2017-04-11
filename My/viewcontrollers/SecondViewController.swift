//
//  SecondViewController.swift
//  App
//
//  Created by 红军张 on 2016/12/16.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        //        viewWillAppear(animated)
        self.view.backgroundColor = rgb(arc4random()%100,arc4random()%202,arc4random()%150)
        Log.info(arc4random()%100)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
//    func squareRectImage(_ image:UIImage,withSize:CGSize)-> UIImage{
//        
//        var size = image.size
//        
//        let basicRatio = withSize.height /  withSize.width
    
//        func  getRectWithSize()-> CGRect{
//            var rect = CGRect()
//            let ratio = size.height / size.width
//            if ratio > basicRatio {
//                rect = CGRect(x: 0, y: (size.height - size.width * basicRatio) / 2.0 , width: size.width, height: size.width * basicRatio)
//            }else{
//                rect = CGRect(x: (size.width - size.height * basicRatio) / 2.0 , y: 0  , width: size.height * basicRatio, height: size.height)
//            }
//            return rect
//        }
//        
//        switch image.imageOrientation {
//        case.up , .upMirrored:
//            return getSubImage(image, rect: getRectWithSize(), rotateOrientation: .up)
//        case.down , .downMirrored:
//            return getSubImage(image, rect: getRectWithSize(), rotateOrientation: .down)
//        case.left , .leftMirrored:
//            size.width = CGFloat( (image.cgImage?.width)!)
//            size.height = CGFloat((image.cgImage?.height)!)
//            return getSubImage(image, rect: getRectWithSize(), rotateOrientation: .down)
//        case.right , .rightMirrored:
//            size.width = CGFloat( (image.cgImage?.width)!)
//            size.height = CGFloat((image.cgImage?.height)!)
//            return getSubImage(image, rect: getRectWithSize(), rotateOrientation: .right)
//            
//        }
//        
//    }
//    func getSubImage(_ originalImage:UIImage , rect:CGRect ,rotateOrientation:UIImageOrientation)-> UIImage{
//        
//        let  subImage = originalImage.cgImage?.cropping(to: rect)!
//        let  smallBounds: CGRect = CGRect(x: 0, y: 0, width: subImage!.width, height: subImage!.height)
//        UIGraphicsBeginImageContext(smallBounds.size)
//        let   context: CGContext = UIGraphicsGetCurrentContext()!
//        context.draw(subImage!, in: smallBounds)
//        let   smallImage =  UIImage(cgImage: subImage!, scale: originalImage.scale, orientation: rotateOrientation)
//        UIGraphicsEndImageContext()
//        return smallImage
//    }
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

//
//  CommonFuntion.swift
//  App
//
//  Created by 红军张 on 16/9/9.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Swiften

//MARK: ----- UIcolor 颜色 rgb
func rgba(_ red: UInt32, _ green: UInt32, _ blue: UInt32, _ alpha: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
}

func rgba(_ hex: UInt32) -> UIColor {
    return rgba(hex >> 24, hex >> 16 & 0xFF, hex >> 8 & 0xFF, CGFloat(hex & 0xFF) / 255)
}

func rgb(_ red: UInt32, _ green: UInt32, _ blue: UInt32) -> UIColor {
    return rgba(red, green, blue, 1.0)
}

func rgb(_ hex: UInt32) -> UIColor {
    return rgba(hex << 8 | 0xFF)
}
/// 延迟执行代码
public func delay(_ seconds: UInt64, task: () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(seconds * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: task)
}

/// 异步执行代码块（先非主线程执行，再返回主线程执行）
public func async(_ backgroundTask: () -> AnyObject!, mainTask: (AnyObject?) -> Void) {
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
        let result = backgroundTask()
        DispatchQueue.main.sync {
            mainTask(result)
        }
    }
}

/// 异步执行代码块（主线程执行）
public func async(_ mainTask: () -> Void) {
    DispatchQueue.main.async(execute: mainTask)
}

/// 顺序执行代码块（在队列中执行）
public func sync(_ task: () -> Void) {
    DispatchQueue(label: "com.catorv.LockQueue", attributes: []).sync(execute: task)
}

func alert(_ message: String, title: String! = nil, completion: (() -> Void)? = nil) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "我知道了", style: .default) { action in
        controller.dismiss(animated: true, completion: nil)
        completion?()
        })
    UIViewController.topViewController?.present(controller, animated: true, completion: nil)
}

func confirm(_ message: String, title: String! = nil, completion: (Bool) -> Void) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "否", style: .cancel) { action in
        controller.dismiss(animated: true, completion: nil)
        completion(false)
        })
    controller.addAction(UIAlertAction(title: "是", style: .default) { action in
        controller.dismiss(animated: true, completion: nil)
        completion(true)
        })
    UIViewController.topViewController?.present(controller, animated: true, completion: nil)
}

func prompt(_ message: String, title: String! = nil, text: String! = nil, placeholder: String! = nil, completion: (String?) -> Void) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
        controller.dismiss(animated: true, completion: nil)
        completion(nil)
        })
    controller.addAction(UIAlertAction(title: "确定", style: .default) { action in
        controller.dismiss(animated: true, completion: nil)
        completion(controller.textFields?[0].text ?? "")
        })
    controller.addTextField { textField in
        if let value = text {
            textField.text = value
        }
        if let ph = placeholder {
            textField.placeholder = ph
        }
    }
    UIViewController.topViewController?.present(controller, animated: true, completion: nil)
}

func toast(_ message: String, duration: Double = HRToastDefaultDuration, position: AnyObject = HRToastPositionDefault, title: String! = nil, image: UIImage! = nil) {
    if let view = UIApplication.shared.keyWindow {
        let toastView = view.viewForMessage(message, title: nil, image: image)
        view.showToast(toastView!)
    }
}
func locationfileiscache(_ fileName: String, complate:(callback: String)->Void){
    guard let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else {
        complate(callback: "")
        return
    }
    // 打印路径,需要测试的可以往这个路径下放东西
//    Log.debug("Clear Cache: \(cachePath)")
    var path = ""
    // 取出文件夹下所有文件数组
    if let files = try? FileManager.default.subpathsOfDirectory(atPath: cachePath){
        // 快速枚举取出所有文件名
        for p in files {
            if p == fileName{
//                Log.info("____找到的文件名字:\(p)")
                path = cachePath.stringByAppendingFormat("/\(p)")
                complate(callback: path)
                return
            }
        }
    }
    complate(callback: "")
}
func fileDownload(_ urlArray: [String],complate:((isok: Bool,callbackData: [Data])->Void)){
    if Reachability.networkStatus == .notReachable {return}
    var dataArray = [Data]()
    //  方法一 自定义下载文件的保存目录 同名文件竟被覆盖
//    Alamofire.download(.GET, "http://www.hangge.com/blog/images/logo.png") {
//        temporaryURL, response in
//        let fileManager = NSFileManager.defaultManager()
//        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,
//                                                        inDomains: .UserDomainMask)[0]
//        let pathComponent = response.suggestedFilename
//        
//        return directoryURL.URLByAppendingPathComponent(pathComponent!)!
//    }
    
    // 方式二
    let destination = Alamofire.Request.suggestedDownloadDestination(
        directory: .DocumentDirectory, domain: .UserDomainMask)
    
    for url in urlArray {
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            Alamofire.download(.GET, url, destination: destination)
                .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                    let percent = totalBytesRead*100/totalBytesExpectedToRead
                    print("已下载：\(totalBytesRead)  总共：\(totalBytesExpectedToRead) 当前进度：\(percent)%")
                }
                .response { (request, response, _, error) in
                    if let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
                        let fileName = response?.suggestedFilename!
                        if let fileName = fileName{
                            let newPath = NSURL(fileURLWithPath: "\(path)/\(fileName)")
//                            print("下载路径：\(newPath)____名称：\(response?.suggestedFilename)")
//                            print(response)
                            let fileManager = NSFileManager.defaultManager()
                            print(fileManager.fileExistsAtPath(newPath.path!))
                            if ( fileManager.fileExistsAtPath(newPath.path!) ) {
//                                print(newPath)
                                let data = NSData(contentsOfURL: newPath)
                                dataArray.append(data!)
                            }else{
                                dataArray.append(NSData())
                                toast("没找到文件")
                                print("创建文件")
                                //                            try {
                                //                                fileManager.removeItemAtURL(newPath)
                                //                                fileManager.moveItemAtURL(NSURL(string: url)!, toURL: newPath)
                                //                            }
                                
                            }
                        }
                    }
                    if dataArray.count == urlArray.count{
                        complate(isok: true, callbackData: dataArray)
                    }else{
                        complate(isok: false, callbackData: dataArray)
                    }
            }
        }
    }
    
}
func RemoveSpecialCharacter(_ str: String) -> String {
    let range = str.rangeOfCharacter(from: CharacterSet(charactersIn: "-,.？、% ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"))
    if range != nil {
        return RemoveSpecialCharacter(str.replacingCharacters(in: range!, with: ""))
    }
    return str
}
// Mark: -------- 手机号正则表达式
func checkMobileReg(_ mobile: String) -> Bool {
    let regex = try! NSRegularExpression(pattern: REGEXP_MOBILES,
                                         options: [.caseInsensitive])
    
    return regex.firstMatch(in: mobile, options: [],
                                    range: NSRange(location: 0, length: mobile.utf16.count))?.range.length != nil
    
}
func Checktheequipmentinformation(){
    /*** Display the device version ***/
    switch Device.version() {
        /*** iPhone ***/
    case .iPhone4:       print("It's an iPhone 4")
    case .iPhone4S:      print("It's an iPhone 4S")
    case .iPhone5:       print("It's an iPhone 5")
    case .iPhone5C:      print("It's an iPhone 5C")
    case .iPhone5S:      print("It's an iPhone 5S")
    case .iPhone6:       print("It's an iPhone 6")
    case .iPhone6S:      print("It's an iPhone 6S")
    case .iPhone6Plus:   print("It's an iPhone 6 Plus")
    case .iPhone6SPlus:  print("It's an iPhone 6 S Plus")
    case .iPhoneSE:      print("It's an iPhone SE")
    case .iPhone7:       print("It's an iPhone 7")
    case .iPhone7Plus:   print("It's an iPhone 7 Plus")
        
        /*** iPad ***/
    case .iPad1:         print("It's an iPad 1")
    case .iPad2:         print("It's an iPad 2")
    case .iPad3:         print("It's an iPad 3")
    case .iPad4:         print("It's an iPad 4")
    case .iPadAir:       print("It's an iPad Air")
    case .iPadAir2:      print("It's an iPad Air 2")
    case .iPadMini:      print("It's an iPad Mini")
    case .iPadMini2:     print("It's an iPad Mini 2")
    case .iPadMini3:     print("It's an iPad Mini 3")
    case .iPadMini4:     print("It's an iPad Mini 4")
    case .iPadPro:       print("It's an iPad Pro")
        
        /*** iPod ***/
    case .iPodTouch1Gen: print("It's a iPod touch generation 1")
    case .iPodTouch2Gen: print("It's a iPod touch generation 2")
    case .iPodTouch3Gen: print("It's a iPod touch generation 3")
    case .iPodTouch4Gen: print("It's a iPod touch generation 4")
    case .iPodTouch5Gen: print("It's a iPod touch generation 5")
    case .iPodTouch6Gen: print("It's a iPod touch generation 6")
        
        /*** Simulator ***/
    case .Simulator:    print("It's a Simulator")
        
        /*** Unknown ***/
    default:            print("It's an unknown device")
    }
    
    /*** Display the device screen size ***/
    switch Device.size() {
    case .screen3_5Inch:  print("It's a 3.5 inch screen")
    case .screen4Inch:    print("It's a 4 inch screen")
    case .screen4_7Inch:  print("It's a 4.7 inch screen")
    case .screen5_5Inch:  print("It's a 5.5 inch screen")
    case .screen7_9Inch:  print("It's a 7.9 inch screen")
    case .screen9_7Inch:  print("It's a 9.7 inch screen")
    case .screen12_9Inch: print("It's a 12.9 inch screen")
    default:              print("Unknown size")
    }
    
    switch Device.type() {
    case .iPod:         print("It's an iPod")
    case .iPhone:       print("It's an iPhone")
    case .iPad:         print("It's an iPad")
    case .Simulator:    print("It's a Simulated device")
    default:            print("Unknown device type")
    }
    
    /*** Helpers ***/
//    if Device.isEqualToScreenSize(Size.screen4Inch) {
//        print("It's a 4 inch screen")
//    }
//    
//    if Device.isLargerThanScreenSize(Size.screen4_7Inch) {
//        print("Your device screen is larger than 4.7 inch")
//    }
//    
//    if Device.isSmallerThanScreenSize(Size.screen4_7Inch) {
//        print("Your device screen is smaller than 4.7 inch")
//    }
}

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
func rgba(red: UInt32, _ green: UInt32, _ blue: UInt32, _ alpha: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
}

func rgba(hex: UInt32) -> UIColor {
    return rgba(hex >> 24, hex >> 16 & 0xFF, hex >> 8 & 0xFF, CGFloat(hex & 0xFF) / 255)
}

func rgb(red: UInt32, _ green: UInt32, _ blue: UInt32) -> UIColor {
    return rgba(red, green, blue, 1.0)
}

func rgb(hex: UInt32) -> UIColor {
    return rgba(hex << 8 | 0xFF)
}
/// 延迟执行代码
public func delay(seconds: UInt64, task: () -> Void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), task)
}

/// 异步执行代码块（先非主线程执行，再返回主线程执行）
public func async(backgroundTask: () -> AnyObject!, mainTask: AnyObject? -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        let result = backgroundTask()
        dispatch_sync(dispatch_get_main_queue()) {
            mainTask(result)
        }
    }
}

/// 异步执行代码块（主线程执行）
public func async(mainTask: () -> Void) {
    dispatch_async(dispatch_get_main_queue(), mainTask)
}

/// 顺序执行代码块（在队列中执行）
public func sync(task: () -> Void) {
    dispatch_sync(dispatch_queue_create("com.catorv.LockQueue", nil), task)
}

func alert(message: String, title: String! = nil, completion: (() -> Void)? = nil) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    controller.addAction(UIAlertAction(title: "我知道了", style: .Default) { action in
        controller.dismissViewControllerAnimated(true, completion: nil)
        completion?()
        })
    UIViewController.topViewController?.presentViewController(controller, animated: true, completion: nil)
}

func confirm(message: String, title: String! = nil, completion: Bool -> Void) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    controller.addAction(UIAlertAction(title: "否", style: .Cancel) { action in
        controller.dismissViewControllerAnimated(true, completion: nil)
        completion(false)
        })
    controller.addAction(UIAlertAction(title: "是", style: .Default) { action in
        controller.dismissViewControllerAnimated(true, completion: nil)
        completion(true)
        })
    UIViewController.topViewController?.presentViewController(controller, animated: true, completion: nil)
}

func prompt(message: String, title: String! = nil, text: String! = nil, placeholder: String! = nil, completion: String? -> Void) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    controller.addAction(UIAlertAction(title: "取消", style: .Cancel) { action in
        controller.dismissViewControllerAnimated(true, completion: nil)
        completion(nil)
        })
    controller.addAction(UIAlertAction(title: "确定", style: .Default) { action in
        controller.dismissViewControllerAnimated(true, completion: nil)
        completion(controller.textFields?[0].text ?? "")
        })
    controller.addTextFieldWithConfigurationHandler { textField in
        if let value = text {
            textField.text = value
        }
        if let ph = placeholder {
            textField.placeholder = ph
        }
    }
    UIViewController.topViewController?.presentViewController(controller, animated: true, completion: nil)
}

func toast(message: String, duration: Double = HRToastDefaultDuration, position: AnyObject = HRToastPositionDefault, title: String! = nil, image: UIImage! = nil) {
    if let view = UIApplication.sharedApplication().keyWindow {
        let toastView = view.viewForMessage(message, title: nil, image: image)
        view.showToast(toastView!)
    }
}
func locationfileiscache(fileName: String, complate:(callback: String)->Void){
    guard let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first else {
        complate(callback: "")
        return
    }
    // 打印路径,需要测试的可以往这个路径下放东西
//    Log.debug("Clear Cache: \(cachePath)")
    var path = ""
    // 取出文件夹下所有文件数组
    if let files = try? NSFileManager.defaultManager().subpathsOfDirectoryAtPath(cachePath){
        // 快速枚举取出所有文件名
        for p in files {
            if p == fileName{
                Log.info("____找到的文件名字:\(p)")
                path = cachePath.stringByAppendingFormat("/\(p)")
                complate(callback: path)
                return
            }
        }
    }
    complate(callback: "")
}
func fileDownload(urlArray: [String],complate:((isok: Bool,callbackData: [NSData])->Void)){
    if Reachability.networkStatus == .notReachable {return}
    var dataArray = [NSData]()
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
                            print("下载路径：\(newPath)____名称：\(response?.suggestedFilename)")
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
func RemoveSpecialCharacter(str: String) -> String {
    let range = str.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "-,.？、% ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"))
    if range != nil {
        return RemoveSpecialCharacter(str.stringByReplacingCharactersInRange(range!, withString: ""))
    }
    return str
}

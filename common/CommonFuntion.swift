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
//import Swiften

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
//MARK:  延迟执行代码
public func delay(_ seconds: UInt64, task: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(seconds * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: task)
}

//MARK: 异步执行代码块（先非主线程执行，再返回主线程执行）
public func async(_ backgroundTask: @escaping () -> AnyObject!, mainTask: @escaping (AnyObject?) -> Void) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
        let result = backgroundTask()
        DispatchQueue.main.sync {
            mainTask(result)
        }
    }
}

//MARK:  异步执行代码块（主线程执行）
public func async(_ mainTask: @escaping () -> Void) {
    DispatchQueue.main.async(execute: mainTask)
}

//MARK:  顺序执行代码块（在队列中执行）
public func sync(_ task: () -> Void) {
    DispatchQueue(label: "com.catorv.LockQueue", attributes: []).sync(execute: task)
}
//MARK: alert提示框
func alert(_ message: String, title: String! = nil, completion: (() -> Void)? = nil) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "我知道了", style: .default) { action in
        controller.dismiss(animated: true, completion: nil)
        completion?()
        })
    UIViewController.topViewController?.present(controller, animated: true, completion: nil)
}

func confirm(_ message: String, title: String! = nil, completion: @escaping (Bool) -> Void) {
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
//MARK: 带textfiled的提示框
func prompt(_ message: String, title: String! = nil, text: String! = nil, placeholder: String! = nil, completion: @escaping (String?) -> Void) {
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
//MARK: 保存图片到本地
func baocunphotoLocation(data: Data?,img: UIImage?)-> Bool{
    let fileManager = FileManager.default
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    if let data = data {
        fileManager.createFile(atPath: cachePath!, contents: data, attributes: nil)
    } else if let image = img {
        let imgdata = UIImageJPEGRepresentation(image.zz_normalizedImage(), 0.9)
        fileManager.createFile(atPath: cachePath!, contents: imgdata, attributes: nil)
    } else {
        return false
    }
    return true
}
//MARK: 从一个本地项目资源中读取data.Json文件
func getProjectJsonFile()-> [String]{
    let path: String = Bundle.main.path(forResource: "uploadPicturesTable", ofType: ".geojson")!
    let nsUrl = NSURL(fileURLWithPath: path)
    //读取Json数据
    do {
        let data: Data = try Data(contentsOf: nsUrl as URL)
        let jsonArray: [String] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String]
        return jsonArray
    }
    catch {
        Log.info("读取文件: uploadPicturesTable.geojson 失败")
        return [""]
    }
}

//MARK: 根据文件名 查找目录下指定文件
func locationfileiscache(_ fileName: String, complate:(_ callback: String)->Void){
    guard var cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else {
        complate("")
        return
    }
    // 打印路径,需要测试的可以往这个路径下放东西
    var path = ""
    cachePath = cachePath + "/"
    // 取出文件夹下所有文件数组
    if let files = try? FileManager.default.subpathsOfDirectory(atPath: cachePath + "/" ){
        // 快速枚举取出所有文件名
        for p in files {
            if p == fileName{
                path = cachePath.appendingFormat("/\(p)")
                complate(path)
                return
            }
        }
    }
    complate("")
}

//MARK:   文件下载
func fileDownload(_ urlArray: [String],complate:@escaping ((_ isok: Bool,_ callbackData: [Data])->Void)){
    if Reachability.networkStatus == .notReachable {return}
    var dataArray = [Data]()
    for url in urlArray {
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            Alamofire.request(url).downloadProgress(queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default), closure: { (Progress) in
//                print("Download Progress: \(String(describing: String(Progress.fractionCompleted * 100).substring(0, 5))))%")
            }).responseJSON { response in
                if let imageData = response.data {
                        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                            var  fileName = ""
                            if let dataName = url.components(separatedBy: "/").last{
                                fileName = dataName
                            }else{ fileName = url.substring(8)!}
                            let newPath = NSURL(fileURLWithPath: "\(path)/\(fileName)")
//                            Log.info("下载路径： \(newPath)____文件名称：\(fileName)")
                            let fileManager = FileManager.default
                            if ( fileManager.fileExists(atPath: newPath.path!) ) { // 如果存在则覆盖 此文件
                                try? imageData.write(to: newPath as URL)
                                dataArray.append(imageData)
                                toast("文件重复，被覆盖")
                            }else{ // 不存在 重复文件
                                dataArray.append(imageData)
                                try? imageData.write(to: newPath as URL)
                                //                                    try {
                                //                                        fileManager.removeItemAtURL(newPath)
                                //                                        fileManager.moveItemAtURL(NSURL(string: url)!, toURL: newPath)
                                //                                    }
                            }
                        }
                    
                        if dataArray.count == urlArray.count{
                            complate(true, dataArray)
                        }else{
                            complate(false, dataArray)
                        }
                    }else{
                    toast("请求gif图片失败")
                }
            }
        }
    }
}
//MARK:  字符串过滤
func RemoveSpecialCharacter(_ str: String) -> String {
    let range = str.rangeOfCharacter(from: CharacterSet(charactersIn: "-,.？、% ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"))
    if range != nil {
        return RemoveSpecialCharacter(str.replacingCharacters(in: range!, with: ""))
    }
    return str
}
//MARK: -------- 手机号正则表达式
func checkMobileReg(_ mobile: String) -> Bool {
    let regex = try! NSRegularExpression(pattern: REGEXP_MOBILES,
                                         options: [.caseInsensitive])
    
    return regex.firstMatch(in: mobile, options: [],
                                    range: NSRange(location: 0, length: mobile.utf16.count))?.range.length != nil
    
}

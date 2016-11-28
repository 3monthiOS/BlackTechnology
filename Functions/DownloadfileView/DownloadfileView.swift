//
//  DownloadfileView.swift
//  App
//
//  Created by 红军张 on 2016/11/25.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
import Alamofire

class DownloadfileView: UIViewController {
    
    //停止下载按钮
    @IBOutlet weak var stopBtn: UIButton!
    //继续下载按钮
    @IBOutlet weak var continueBtn: UIButton!
    //下载进度条
    @IBOutlet weak var progress: UIProgressView!
    
    
    //下载文件的保存路径
    let destination = Alamofire.Request.suggestedDownloadDestination(
        directory: .DocumentDirectory, domain: .UserDomainMask)
    
    //用于停止下载时，保存已下载的部分
    var cancelledData: NSData?
    
    //下载请求对象
    var downloadRequest: Request!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //页面加载完毕就自动开始下载
        self.downloadRequest =  Alamofire.download(.GET,
                                                   "http://dldir1.qq.com/qqfile/qq/QQ7.9/16621/QQ7.9.exe",
                                                   destination: destination)
        
        self.downloadRequest.progress(downloadProgress) //下载进度
        
        self.downloadRequest.response(completionHandler: downloadResponse) //下载停止响应
    }
    
    //下载过程中改变进度条
    func downloadProgress(bytesRead: Int64, totalBytesRead: Int64,
                          totalBytesExpectedToRead: Int64) {
        let percent = Float(totalBytesRead)/Float(totalBytesExpectedToRead)
        
        //进度条更新
        dispatch_async(dispatch_get_main_queue(), {
            self.progress.setProgress(percent,animated:true)
        })
        print("当前进度：\(percent*100)%")
    }
    
    //下载停止响应（不管成功或者失败）
    func downloadResponse(request: NSURLRequest?, response: NSHTTPURLResponse?,
                          data: NSData?, error:NSError?) {
        if let error = error {
            if error.code == NSURLErrorCancelled {
                self.cancelledData = data //意外终止的话，把已下载的数据储存起来
            } else {
                print("Failed to download file: \(response) \(error)")
            }
        } else {
            print("Successfully downloaded file: \(response)")
        }
    }
    
    //停止按钮点击
    @IBAction func stopBtnClick(sender: AnyObject) {
        self.downloadRequest?.cancel()
        self.stopBtn.enabled = false
        self.continueBtn.enabled = true
    }
    
    //继续按钮点击
    @IBAction func continueBtnClick(sender: AnyObject) {
        if let cancelledData = self.cancelledData {
            self.downloadRequest = Alamofire.download(resumeData: cancelledData,
                                                      destination: destination)
            
            self.downloadRequest.progress(downloadProgress) //下载进度
            
            self.downloadRequest.response(completionHandler: downloadResponse) //下载停止响应
            
            self.stopBtn.enabled = true
            self.continueBtn.enabled = false
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

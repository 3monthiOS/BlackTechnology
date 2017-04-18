//
//  ViewController.swift
//  App
//
//  Created by 红军张 on 16/9/6.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func lauchscreenLoadingGIF(){
        let launchView = UIViewController.loadViewControllerFromStoryboard("LaunchScreen", storyboardID: "LaunchScreen")!.view
        let mainWindow = UIApplication.shared.keyWindow//获取到app的主屏幕
        launchView?.frame = view.frame
        mainWindow?.addSubview(launchView!)//将自定义的View加载在主屏上
        
        let filePath = Bundle.main.path(forResource: "gif131", ofType: "gif")
        let gif = try? Data(contentsOf: URL(fileURLWithPath: filePath!))
        let webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.load(gif!, mimeType: "image/gif", textEncodingName: String(), baseURL: URL(string: "")!)
        webViewBG.isUserInteractionEnabled = false;
        self.view.addSubview(webViewBG)
        let filter = UIView()
        filter.frame = self.view.frame
        filter.backgroundColor = UIColor.black
        filter.alpha = 0.05
        self.view.addSubview(filter)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  APPviewcontroller.swift
//  App
//
//  Created by 红军张 on 16/9/12.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import Foundation
class APPviewcontroller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.loadData()
        self.edgesForExtendedLayout = .Top      //向上延伸
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let pageId = String(self.classForCoder)
        Log.info("navigate: \(pageId) will appear")
//        MobClick.beginLogPageView(pageId)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let pageId = String(self.classForCoder)
        Log.info("navigate: \(pageId) will disappear")
//        MobClick.endLogPageView(pageId)
    }
    
    /// 加载数据
    func loadData() {
        //
    }
    
    /// 设置
    func setupSubviews() {
        //
    }
    
    func isCurrentViewControllerVisible() -> Bool {
        return self.view.window == nil ? false :true
    }
}
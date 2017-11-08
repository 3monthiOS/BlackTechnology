//
//  ChatListviewcontroller.swift
//  App
//
//  Created by 红军张 on 16/9/12.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import Alamofire
import TYPagerController

class ChatListviewcontroller: CustomViewController {
    
    lazy var tabBar = TYTabPagerBar()
    lazy var pagerController = TYPagerController()
    lazy var datas = [String]()
    
    var request : ApiService?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bar = self.tabBarController as! RAMAnimatedTabBarController
        bar.hideAndShowCustomIcons(isHidden: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tabBar.frame = CGRect(x: 0, y: APP_tabbarHeight, width: Int(App_width), height: 40)
        self.pagerController.view.frame = CGRect(x: 0, y: self.tabBar.frame.maxY, width: App_width, height: App_height - self.tabBar.frame.maxY)
    }
    
    override func setup() {
        super.setup()
        
        self.addTabPagerBar()
        self.addPagerController()
        self.loadData()
        createCurrentNagationBaritem()
        // MARK: -- 请求测试
//        requestTest()
    }
    
    func addTabPagerBar() {
        self.tabBar.delegate = self
        self.tabBar.dataSource = self
        self.tabBar.register(TYTabPagerBarCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()))
        self.view.addSubview(self.tabBar)
    }
    
    func addPagerController() {
        self.pagerController.dataSource = self
        self.pagerController.delegate = self
        self.addChildViewController(self.pagerController)
        self.view.addSubview(self.pagerController.view)
    }
    
    func loadData() {
        datas = ["RCsessionListcontroller","RCcontactPersonController","RCsetingController"]
        self.reloadData()
    }
    
    func reloadData() {
        self.tabBar.reloadData()
        self.pagerController.reloadData()
    }
    
    // MARK: -- rc 用户信息
    func createCurrentNagationBaritem() {
        let _ = createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.left, Title: "", normalImage: UIImage(named: "bottom_personal_selected"), highlightImage: UIImage(), action: #selector(privateChat))
    }
    
    func privateChat() {
//        let RCSeting = RCsetingsController()
//        let bar = self.tabBarController as! RAMAnimatedTabBarController
//        bar.hideAndShowCustomIcons(isHidden: true)
//        self.navigationController?.pushViewController(RCSeting, animated: true)
    }
}

// MARK: -----  TYTabPagerBarDataSource   TYTabPagerBarDelegate
extension ChatListviewcontroller: TYTabPagerBarDataSource, TYTabPagerBarDelegate {
    func numberOfItemsInPagerTabBar() -> Int {
        return self.datas.count
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()), for: index)
        let name = ["聊天室","联系人","设置","第四个"]
        (cell as? TYTabPagerBarCellProtocol)?.titleLabel.text = name[index]
        return cell
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        if datas.count < 6 {
            return App_width/datas.count
        } else {
            let name = ["聊天室","联系人","设置","第四个"]
            return pagerTabBar.cellWidth(forTitle: name[index])
        }
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
        self.pagerController.scrollToController(at: index, animate: true);
    }
}

extension ChatListviewcontroller: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return self.datas.count
    }
    
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        return VCSTRING_TO_VIEWCONTROLLER(self.datas[index]) ?? UIViewController()
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        self.tabBar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        self.tabBar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
    }
}


// MARK: -- 请求测试
extension ChatListviewcontroller {
    
    func requestTest(){
//        HttpClient.default.adapter = AccessTokenAdapter()
//        HttpClient.defaultEncoding = JerseyEncoding.default
//        HttpClient.errorFieldName = "msg"
//        testParam()
    }
    
    func testParam() {
        testObject()
    }
    
    func testObject() {
        Api.testArrayStringBaiDu.call { (response: ApiObjectResponse<MessageBody>) in
            if let value = response.value {
                let json = value.toJSONString()
                Log.info("\(String(describing: json))")
            }
        }
    }

}

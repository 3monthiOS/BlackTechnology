//
//  Myviewcontroller.swift
//  App
//
//  Created by 红军张 on 16/9/13.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
//import Swiften
import SnapKit
import TYPagerController

class Myviewcontroller: APPviewcontroller {
    
    lazy var tabBar = TYTabPagerBar()
    lazy var pagerController = TYPagerController()
    lazy var datas = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bar = self.tabBarController as! RAMAnimatedTabBarController
        bar.hideAndShowCustomIcons(isHidden: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tabBar.frame = CGRect(x: 0, y: self.tabBarController?.tabBar.bottom ?? 0, width: self.view.frame.width, height: 40)
        self.pagerController.view.frame = CGRect(x: 0, y: self.tabBar.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - self.tabBar.frame.maxY)
    }
    
    override func setup() {
        super.setup()
         self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "我"
        
        self.view.backgroundColor = UIColor.white
        self.addTabPagerBar()
        self.addPagerController()
        self.loadData()
        
        createCurrentNagationBaritem()
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
        datas = ["FirstViewController","FirstViewController","FirstViewController","FirstViewController","FirstViewController","FirstViewController","FirstViewController","FirstViewController","FirstViewController"]
        self.reloadData()
    }
    
    func reloadData() {
        self.tabBar.reloadData()
        self.pagerController.reloadData()
    }
   
    // MARK: -- 导航栏 添加用户信息
    func createCurrentNagationBaritem() {
        let _ = createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.right, Title: "", normalImage: UIImage(named: "bottom_personal_selected"), highlightImage: UIImage(named: "bottom_personal_selected"), action: #selector(userInfoShow))
    }
    
    @objc private func  userInfoShow() {
        let story = UIViewController.loadViewControllerFromStoryboard("User", storyboardID: "UserInfoController")
        self.navigationController?.pushViewController(story!, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: -----  TYTabPagerBarDataSource   TYTabPagerBarDelegate
extension Myviewcontroller: TYTabPagerBarDataSource, TYTabPagerBarDelegate {
    func numberOfItemsInPagerTabBar() -> Int {
        return self.datas.count
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()), for: index)
        let name = ["iOS文章","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个"]
        (cell as? TYTabPagerBarCellProtocol)?.titleLabel.text = name[index]
        return cell
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        let name = ["iOS文章","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个"]
        return pagerTabBar.cellWidth(forTitle: name[index])
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
        self.pagerController.scrollToController(at: index, animate: true);
    }
}

extension Myviewcontroller: TYPagerControllerDataSource, TYPagerControllerDelegate {
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


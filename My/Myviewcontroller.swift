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

class Myviewcontroller: APPviewcontroller{
    
    let conreollerName = ["FirstViewController","FirstViewController","FirstViewController","FirstViewController","FirstViewController","FirstViewController","FirstViewController","FirstViewController","FirstViewController"]
    var controllers = [UIViewController]()
    var pagerController:TYTabButtonPagerController?
    
//    @IBOutlet weak var contentview: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bar = self.tabBarController as! RAMAnimatedTabBarController
        bar.hideAndShowCustomIcons(isHidden: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let bar = self.tabBarController as! RAMAnimatedTabBarController
        bar.hideAndShowCustomIcons(isHidden: true)
    }
    
    override func setup() {
        super.setup()
         self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "我"
        loadTabs()
        addPagerController()
        self.pagerController!.reloadData()
        self.pagerController?.moveToController(at: 0, animated: false)
        
        createCurrentNagationBaritem()
    }
   
    func addPagerController(){
        
        let  pager = TYTabButtonPagerController()
        pager.dataSource = self
        pager.moreDelegate = self
        
        pager.adjustStatusBarHeight = false
        pager.barStyle = .noneView
        
        pager.contentTopEdging = 36
        
        pager.normalTextColor = rgb(333333)
        pager.selectedTextColor = rgb(0xEE2E37)
        
        pager.normalTextFont = UIFont.boldSystemFont(ofSize: 15.0)
        pager.selectedTextFont = UIFont.boldSystemFont(ofSize: 15.0)
        
        pager.cellWidth = 0
        
        pager.cellEdging = 10
        pager.cellSpacing = 10
        
        self.addChildViewController(pager)
        self.view.addSubview(pager.view)
        
        self.pagerController = pager
        self.pagerController?.view.backgroundColor = UIColor.groupTableViewBackground
        
        pager.view.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        self.view.updateConstraints()
    }
    
    // MARK: -- 导航栏 添加用户信息
    func createCurrentNagationBaritem() {
        let _ = createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.right, Title: "", normalImage: UIImage(named: "bottom_personal_selected"), highlightImage: UIImage(named: "bottom_personal_selected"), action: #selector(userInfoShow))
    }
    
    @objc private func  userInfoShow() {
        let story = UIViewController.loadViewControllerFromStoryboard("User", storyboardID: "UserInfoController")
        self.navigationController?.pushViewController(story!, animated: true)
    }
    
    // 加载不同的页面到 viewcontrollers
    func  loadTabs(){
        for classname in conreollerName {
            let controller = VCSTRING_TO_VIEWCONTROLLER(classname)
            self.controllers.append(controller!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func VCSTRING_TO_VIEWCONTROLLER(_ childControllerName: String) -> UIViewController?{
        // 1.获取命名空间
        // 通过字典的键来取值,如果键名不存在,那么取出来的值有可能就为没值.所以通过字典取出的值的类型为AnyObject?
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            print("命名空间不存在")
            return nil
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + childControllerName)
        
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            print("无法转换成UIViewController")
            return nil
        }
        // 3.通过Class创建对象
        let childController = clsType.init()
        
        return childController
    }
    
  
    //创建高斯模糊效果的背景
    func createBlurBackground (_ image:UIImage,view:UIView,blurRadius:Float) {
        //处理原始NSData数据
        let originImage = CIImage(cgImage: image.cgImage!)
        //创建高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")
        filter!.setValue(originImage, forKey: kCIInputImageKey)
        filter!.setValue(NSNumber(value: blurRadius as Float), forKey: "inputRadius")
        //生成模糊图片
        let context = CIContext(options: nil)
        let result:CIImage = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let blurImage = UIImage(cgImage: context.createCGImage(result, from: result.extent)!)
        //将模糊图片加入背景
        let blurImageView = UIImageView(frame: view.frame)
        blurImageView.clipsToBounds = true
        blurImageView.contentMode = UIViewContentMode.scaleAspectFill
        //        blurImageView.autoresizingMask = [.FlexibleWidth ,.FlexibleHeight]
        blurImageView.image = blurImage
        view.addSubview(blurImageView)
    }
}
extension Myviewcontroller: TYTabPagerControllerDelegateExtension{
    //TYTabButtonPagerControllerDelegate
    func pagerController(_ pagerController: TYTabPagerController!, didSelectMoreButton button: UIButton!) {
        
    }
    func pagerController(_ pagerController: TYTabPagerController!, didSelectAt indexPath: IndexPath!) {
        //        let category = self.categories[indexPath.item]
        //        self.navigationController?.title = category.title
    }
    
}
extension Myviewcontroller: TYPagerControllerDataSource{
    // MARK: TYPagerControllerDataSource
    func numberOfControllersInPagerController() -> Int {
        return self.conreollerName.count
//        return 1
    }
    
    func pagerController(_ pagerController: TYPagerController!, titleFor index: Int) -> String! {
        let name = ["iOS文章","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个"]
        let titlename = name[index]
        return titlename
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController? {
        
        let viewController = self.controllers[index]
        return viewController
    }
}



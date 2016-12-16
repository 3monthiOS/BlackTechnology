//
//  Myviewcontroller.swift
//  App
//
//  Created by 红军张 on 16/9/13.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
import Swiften

class Myviewcontroller: APPviewcontroller{
    
    let conreollerName = ["MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView"]
    var controllers = [UIViewController]()
    var pagerController:TYTabButtonPagerController?
    
//    @IBOutlet weak var contentview: UIView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationItem.title = "我"
        loadTabs()
        addPagerController()
        self.pagerController!.reloadData()
        self.pagerController?.moveToControllerAtIndex(0, animated: false)
    }
    
    func addPagerController(){
        
        let  pager = TYTabButtonPagerController()
        pager.dataSource = self
        pager.moreDelegate = self
        
        pager.adjustStatusBarHeight = false
        pager.barStyle = .NoneView
        
        pager.contentTopEdging = 36
        
        pager.normalTextColor = rgb(333333)
        pager.selectedTextColor = rgb(0xEE2E37)
        
        pager.normalTextFont = UIFont.boldSystemFontOfSize(15.0)
        pager.selectedTextFont = UIFont.boldSystemFontOfSize(15.0)
        
        pager.cellWidth = 0
        
        pager.cellEdging = 10
        pager.cellSpacing = 10
        
        self.addChildViewController(pager)
        self.view.addSubview(pager.view)
        
        self.pagerController = pager
        self.pagerController?.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        pager.view.snp_makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        self.view.updateConstraints()
        
    }
    // 加载不同的页面到 viewcontrollers
    func  loadTabs(){
        for _ in conreollerName {
        let controller = FirstViewController(nibName: "FirstViewController", bundle: nil)
//            let controller = SecondViewController(nibName: "SecondViewController", bundle: nil)
            self.controllers.append(controller)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
  
    //创建高斯模糊效果的背景
    func createBlurBackground (image:UIImage,view:UIView,blurRadius:Float) {
        //处理原始NSData数据
        let originImage = CIImage(CGImage: image.CGImage!)
        //创建高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")
        filter!.setValue(originImage, forKey: kCIInputImageKey)
        filter!.setValue(NSNumber(float: blurRadius), forKey: "inputRadius")
        //生成模糊图片
        let context = CIContext(options: nil)
        let result:CIImage = filter!.valueForKey(kCIOutputImageKey) as! CIImage
        let blurImage = UIImage(CGImage: context.createCGImage(result, fromRect: result.extent)!)
        //将模糊图片加入背景
        let blurImageView = UIImageView(frame: view.frame)
        blurImageView.clipsToBounds = true
        blurImageView.contentMode = UIViewContentMode.ScaleAspectFill
        //        blurImageView.autoresizingMask = [.FlexibleWidth ,.FlexibleHeight]
        blurImageView.image = blurImage
        view.addSubview(blurImageView)
    }
}
extension Myviewcontroller: TYTabPagerControllerDelegateExtension{
    //TYTabButtonPagerControllerDelegate
    func pagerController(pagerController: TYTabPagerController!, didSelectMoreButton button: UIButton!) {
        
    }
    func pagerController(pagerController: TYTabPagerController!, didSelectAtIndexPath indexPath: NSIndexPath!) {
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
    
    func pagerController(pagerController: TYPagerController!, titleForIndex index: Int) -> String! {
        let name = ["第一个","第二个","第三个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个"]
        let titlename = name[index]
        return titlename
    }
    
    func pagerController(pagerController: TYPagerController!, controllerForIndex index: Int) -> UIViewController? {
        
        let viewController = self.controllers[index]
        return viewController
    }
}



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
    
    let conreollerName = ["MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView","MyinfoControllerView"]
    var controllers = [UIViewController]()
    var pagerController:TYTabButtonPagerController?
    
//    @IBOutlet weak var contentview: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "我"
        loadTabs()
        addPagerController()
        self.pagerController!.reloadData()
        self.pagerController?.moveToController(at: 0, animated: false)
        
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
        let name = ["第一个","第二个","第三个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个","第四个"]
        let titlename = name[index]
        return titlename
    }
    
    func pagerController(_ pagerController: TYPagerController!, controllerFor index: Int) -> UIViewController? {
        
        let viewController = self.controllers[index]
        return viewController
    }
}



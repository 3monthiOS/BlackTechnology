//
//  HomeTabBarController.swift
//  App
//
//  Created by 红军张 on 16/9/9.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.view.backgroundColor = UIColor.white
        showQDT()
    }
    func showQDT(){
        if let userinfos: User = cache.object(forKey: CacheManager.Key.User.rawValue){
            if userinfos.one_t != 1 {
                let lauchImageView   = UIImageView(frame: self.view.bounds)
                lauchImageView.image = AppleSystemService.launchImage()
                view.addSubview(lauchImageView)
                UIView.animate(withDuration: 1, delay: 1, options: UIViewAnimationOptions(), animations: {
                    lauchImageView.scale = 1.5
                    lauchImageView.alpha = 0
                }) { (finished) in
                    lauchImageView.removeFromSuperview()
                }
            }
            if let userinfos: User = cache.object(forKey: CacheManager.Key.User.rawValue){
                userinfos.one_t = 0
                cache.setObject(userinfos, forKey: CacheManager.Key.User.rawValue)
            }
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            item.title = "聊天"
        case 1:
            item.title = "功能列表"
        case 2:
            item.title = "我"
        default:
            item.title = "其他"
        }
    }
    
//    - (void)drawRect:(CGRect)rect {
//    
//    //1.获得图形上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    //2.画文字
//    NSString *str = @"哈哈哈哈";
//    [str drawAtPoint:CGPointZero withAttributes:nil];
//    
//    //文字属性字典
//    NSMutableDictionary *atts = [NSMutableDictionary dictionary];
//    atts[NSForegroundColorAttributeName] = [UIColor redColor];
//    atts[NSFontAttributeName] = [UIFont systemFontOfSize:20];
//    
//    [str drawInRect:CGRectMake(50, 50, 100, 100) withAttributes:atts];
//    
//    //3.渲染显示到view上
//    CGContextStrokePath(ctx);
//    
//    }
    func drawRect(_ rect: CGRect) {
//        let ctx = UIGraphicsGetCurrentContext()
//        let str = "军"
//        str.dr
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

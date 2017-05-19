//
//  ViewController.swift
//  App
//
//  Created by 红军张 on 2017/5/19.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class TabbarHomeController: RAMAnimatedTabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

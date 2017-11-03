//
//  UserInfoController.swift
//  App
//
//  Created by 红军张 on 2017/10/18.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class UserInfoController: UIViewController {

    @IBOutlet weak var userIphone: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userTX: UIImageView!
    @IBOutlet weak var table_user: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
extension UserInfoController :UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell0")
            let img = cell?.contentView.viewWithTag(500) as! UIImageView
            img.clipsToBounds = true
            img.layer.masksToBounds = true
            img.layer.cornerRadius = img.bounds.width/2
            img.layer.borderColor = UIColor.white.cgColor
            img.layer.borderWidth = 1
            let name = cell?.contentView.viewWithTag(501) as! UILabel
            if let portrait = user.thirdPortrait {
                img.af_setImage(withURL: URL(string: portrait)!, placeholderImage: UIImage(named: "owl-login"))
                name.text = user.thirdName
            }
            return cell!
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            let iphone = cell?.contentView.viewWithTag(502) as! UILabel
            iphone.text = user.userphone
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            confirm("良心不在，即可退出", completion: { (isok) in
                if isok {
                    user = cache.object(forKey: CacheManager.Key.User.rawValue)!
                    user.state = 0
                    user.one_t = 1
                    cache.setObject(user, forKey: CacheManager.Key.User.rawValue)
                    toast("您已退出登录")
                }
            })
        }
    }
    
}

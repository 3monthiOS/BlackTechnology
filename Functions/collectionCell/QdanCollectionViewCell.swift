//
//  QdanCollectionViewCell.swift
//  aha
//
//  Created by 红军张 on 16/8/30.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit
//import Swiften

class QdanCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bottrm: NSLayoutConstraint!
    @IBOutlet weak var btn: UIImageView!
    @IBOutlet weak var titleLabel: ZHJRunningLight!
    var viewcontroller: FunctionsViewController? = nil
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      self.clipsToBounds = false
      self.layer.cornerRadius = 5
      self.layer.shadowOffset = CGSize(width: 0, height: SIZE_1PX)
      self.layer.shadowColor = rgb(0,0,0).withAlphaComponent(0.25).cgColor
      self.layer.shadowRadius = SIZE_1PX
      self.layer.shadowOpacity = 1
      self.backgroundColor = UIColor.white
      
        initButtonUI(btn)
        btn.contentMode = .scaleAspectFill
        let cellwidth = (App_width - 24 - 24)/4
        titleLabel.zhjSize = CGSize(width: cellwidth, height: 15)
        titleLabel.bgColor = UIColor.white
        titleLabel.textColor = rgb(198, 198, 198)
//        titleLabel.width = self.contentView.bounds.width  这里的这个空间宽度不对
//        titleLabel.slidingSpeed = 0.1
    }
    
    func bindData(_ imageName: [String],functionTitle: [String], atIndex indexPath: IndexPath ,VC viewcontroller:UIViewController) {
        self.viewcontroller = viewcontroller as? FunctionsViewController
        // isAinmationStatus 监听这个状态 来决定是否开始动画
//        Log.info("加载第\(indexPath.row)行")
        index = indexPath
        let imagename = imageName[(index?.row)!]
        btn.contentMode = .scaleAspectFill
        self.titleLabel.zhj_setTextAndFont(text: functionTitle[(self.index?.row)!], font: UIFont.systemFont(ofSize: 9.0))
        
        async {
            if !imagename.isEmpty{
                if var str = imagename.components(separatedBy: "/").last{
                    if let ImgName = str.components(separatedBy: "?").first{
                        str = ImgName// 由于之前图片来源不一样所以这样 操作
                    }
//                    Log.info("根据什么照图片----\(str)")
                    locationfileiscache(str, complate: { (callback) in
                        if !callback.isEmpty{
                            guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: callback)) else {return}
                            self.btn.setGifImage(UIImage(gifData: imageData, levelOfIntegrity: 1.0))
//                            self.btn.stopAnimatingGif()
                        }else{
                            //网络获取
                            if imagename.hasPrefix("http://") || imagename.hasPrefix("https://") {
                                if Reachability.networkStatus != .notReachable {
                                    fileDownload([imagename], complate: { (isok, callbackData) in
                                        if isok{
                                            self.btn.setGifImage(UIImage(gifData: callbackData[0], levelOfIntegrity: 1.0))
//                                            self.btn.stopAnimatingGif()
//                                            self.btn.image = UIImage.gifWithData(callbackData[0])
                                        }
                                    })
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    func initButtonUI(_ btn: UIImageView) {
        self.btn.updateCurrentImage()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 3
    }
    
    // 是否开始动画
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isAinmationStatus" {
            if self.viewcontroller!.isAinmationStatus {
//                Log.info("第\(String(describing: index?.row))行开始动画")
                self.btn.startAnimatingGif()
            }else{
                self.btn.stopAnimatingGif()
            }
        }
    }
    deinit {
        self.viewcontroller?.removeObserver(self, forKeyPath: "isAinmationStatus", context: nil)
    }
}


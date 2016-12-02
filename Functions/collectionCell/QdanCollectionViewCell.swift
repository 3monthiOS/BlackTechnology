//
//  QdanCollectionViewCell.swift
//  aha
//
//  Created by 红军张 on 16/8/30.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit
import Swiften

class QdanCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bottrm: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var lift: NSLayoutConstraint!
    @IBOutlet weak var right: NSLayoutConstraint!
    @IBOutlet weak var btn: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var index: NSIndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
      self.clipsToBounds = false
      self.layer.cornerRadius = 5
      self.layer.shadowOffset = CGSizeMake(0, SIZE_1PX)
      self.layer.shadowColor = rgb(0,0,0).colorWithAlphaComponent(0.25).CGColor
      self.layer.shadowRadius = SIZE_1PX
      self.layer.shadowOpacity = 1
      self.backgroundColor = UIColor.whiteColor()
      
        initButtonUI(btn)
        btn.contentMode = .ScaleAspectFill
    }
    
    func bindData(imageName: [String],functionTitle: [String], atIndex indexPath: NSIndexPath) {
        btn.image = UIImage(named:"加载失败")
        index = indexPath
        let imagename = imageName[(index?.row)!]
        btn.contentMode = .ScaleAspectFill
        titleLabel.text = functionTitle[(index?.row)!]
        async { 
            if !imagename.isEmpty{
                if let str = imagename.componentsSeparatedByString("/").last{
                    locationfileiscache(str, complate: { (callback) in
                        if !callback.isEmpty{
                            guard let imageData = NSData(contentsOfFile: callback) else {return}
                            self.btn.image = UIImage.gifWithData(imageData)
                        }else{
                            Log.info("我没有找到：————————\(str)")
                            //网络获取
                            if imagename.hasPrefix("http://") || imagename.hasPrefix("https://") {
                                if Reachability.networkStatus != .notReachable {
                                    fileDownload([imagename], complate: { (isok, callbackData) in
                                        if isok{
                                            self.btn.image = UIImage.gifWithData(callbackData[0])
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
    func initButtonUI(btn: UIImageView) {
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 3
    }
}


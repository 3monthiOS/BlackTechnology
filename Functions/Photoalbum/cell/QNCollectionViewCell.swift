//
//  QdanCollectionViewCell.swift
//  aha
//
//  Created by 红军张 on 16/8/30.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit
import Swiften

class QNCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgview: UIImageView!
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
      
        initButtonUI(imgview)
        imgview.contentMode = .ScaleAspectFill
    }
    
    func bindData(imageName: [String],functionTitle: [String], atIndex indexPath: NSIndexPath) {
        imgview.image = UIImage(named:"加载失败")
        index = indexPath
        let imagename = imageName[(index?.row)!]
        imgview.contentMode = .ScaleAspectFill
        async {
            if !imagename.isEmpty{
                if let str = imagename.componentsSeparatedByString("/").last{
                    self.titleLabel.text = str
                    locationfileiscache(str, complate: { (callback) in
                        if !callback.isEmpty{
                            guard let imageData = NSData(contentsOfFile: callback) else {return}
                            self.imgview.image = UIImage.gifWithData(imageData)
                        }else{
                            Log.info("我没有找到：————————\(str)")
                            //网络获取
                            if imagename.hasPrefix("http://") || imagename.hasPrefix("https://") {
                                if Reachability.networkStatus != .notReachable {
                                    fileDownload([imagename], complate: { (isok, callbackData) in
                                        if isok{
                                            self.imgview.image = UIImage.gifWithData(callbackData[0])
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


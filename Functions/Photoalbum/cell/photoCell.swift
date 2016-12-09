//
//  photoCell.swift
//  App
//
//  Created by 红军张 on 2016/12/7.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
import Swiften

class photoCell: UITableViewCell {
    
    @IBOutlet weak var backgroundview: UIView!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var titllabel: UILabel!
    var index: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
        titllabel.text = functionTitle[(index?.row)!]
        async {
            if !imagename.isEmpty{
                if let str = imagename.componentsSeparatedByString("/").last{
                    locationfileiscache(str, complate: { (callback) in
                        if !callback.isEmpty{
                            guard let imageData = NSData(contentsOfFile: callback) else {return}
                            self.imgview.image = UIImage.gifWithData(imageData)
                        }else{
                            Log.info("我没有找到：————————\(str)")
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
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

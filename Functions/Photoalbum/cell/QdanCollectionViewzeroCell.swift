//
//  QdanCollectionViewzeroCell.swift
//  aha
//
//  Created by 红军张 on 16/9/8.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit

class QdanCollectionViewzeroCell: UICollectionViewCell {

    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var liftligh: NSLayoutConstraint!
    @IBOutlet weak var imageviews: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let width = (App_width - 24 - 24)/4
        let hight = (App_width - 24 - 24)/4 * 33/28 - 2
        top.constant = hight/16 * 4
        liftligh.constant = width/7 * 2
//        imageviews.image = UIImage(named: "button_添加1")
        
    }

}

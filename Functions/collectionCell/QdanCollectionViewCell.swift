//
//  QdanCollectionViewCell.swift
//  aha
//
//  Created by 红军张 on 16/8/30.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit

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
    index = indexPath
        let imagename = imageName[(index?.row)!]
        btn.image = UIImage.gifWithName(imagename)
        btn.contentMode = .ScaleAspectFill
        titleLabel.text = functionTitle[(index?.row)!]
    }
    func initButtonUI(btn: UIImageView) {
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 3
    }
}


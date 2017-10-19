//
//  articlesCell.swift
//  App
//
//  Created by 红军张 on 2017/10/18.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class articlesCell: UITableViewCell {

    @IBOutlet weak var readNumber: UILabel!
    @IBOutlet weak var contentText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

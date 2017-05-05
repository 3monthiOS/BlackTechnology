//
//  ShowtextModelCell.swift
//  App
//
//  Created by 红军张 on 2017/5/5.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class ShowtextModelCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.label.numberOfLines = 3
    }
    func starAnimation(isok :Bool){
        self.label.numberOfLines = isok ? 0 : 3
        UIView.animate(withDuration: 0.5) {
            self.label.textColor = isok ? UIColor.black.alpha(0.3) : UIColor.black.alpha(1)
        }
    }
    func updateWithNewCellHeight(_ tableview : UITableView,ShowText :ShowTextModel, animated : Bool = true) {
        starAnimation(isok: !ShowText.isContraction)
        if animated {
            tableview.beginUpdates()
            tableview.endUpdates()
        } else {
            tableview.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

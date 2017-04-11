//
//  UserIphoneNumbercell.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/7/6.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import UIKit

class UserIphoneNumbercell: UITableViewCell {

	@IBOutlet weak var usernumber: UILabel!
	@IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatars: UIImageView!
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	func getData(_ MOB: MobileAddress) {
		self.username.text = MOB.name

		self.usernumber.text = MOB.mobile
        if MOB.avatars != nil{
            self.avatars.image = MOB.avatars
        }
        
        avatars.layer.masksToBounds = true
        avatars.layer.cornerRadius = 3
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

}

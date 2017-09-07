//
//  adfsdgfhgViewController.swift
//  App
//
//  Created by 红军张 on 2017/8/18.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class RoastingViewController: UIViewController {

    let paomadeng :AYScrollerLabel? = {
        return AYScrollerLabel(frame: CGRect(x: 100, y: 100, width: App_width-24, height: 44))
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.view.addSubview(paomadeng!)
        paomadeng?.snp.makeConstraints({ (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(App_width-24)
            make.height.equalTo(44)
        })
        paomadeng?.bgColor = UIColor.green
        paomadeng?.text = "此app版权未公开，请勿copy。            此app版权未公开，请勿copy"
        paomadeng?.textColor = UIColor.white
        
        paomadeng?.ay_setPaused(false)
    }
}

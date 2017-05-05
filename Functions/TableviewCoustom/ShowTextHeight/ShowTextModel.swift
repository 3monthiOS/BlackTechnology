//
//  ShowTextModel.swift
//  Swift-Animations
//
//  Created by YouXianMing on 16/8/30.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit
//import

class ShowTextModel: NSObject {
    
    var inputString        : String?
    var expendStringHeight : CGFloat?
    var normalStringHeight : CGFloat?
    var isContraction = true
    
    convenience init(_ inputString : String) {
        
        self.init()
        self.inputString = inputString
        self.HeightWithData()
    }
    func HeightWithData(){
        expendStringHeight = (inputString?.heightWithFont(UIFont.HeitiSC(15), width: Width()))!
        normalStringHeight = 6 + (inputString?.HeightWithFont(coustom: UIFont.HeitiSC(16)))! * CGFloat(3) + 6
    }
}

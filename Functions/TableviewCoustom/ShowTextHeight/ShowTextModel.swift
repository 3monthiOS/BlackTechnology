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
        expendStringHeight = (inputString?.WithStrigFontSize(nil, sizeFont: 15.0, width: Width()))?.height
        normalStringHeight = 6 + (inputString?.WithStrigFontSize(nil, sizeFont: 16.0, width: nil).height)! * CGFloat(3) + 6
    }
}

//
//  String+Size.swift
//  aha
//
//  Created by Cator Vee on 12/12/15.
//  Copyright © 2015 Ledong. All rights reserved.
//

import Foundation

extension String {
	
	func heightWithFontSize(fontSize: CGFloat, width: CGFloat) -> CGFloat {
		return heightWithFont(UIFont.systemFontOfSize(fontSize), width: width)
	}
    
    func heightWithFont(font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSizeMake(width, CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
	
	func widthWithFontSize(fontSize: CGFloat) -> CGFloat {
		return widthWithFont(UIFont.systemFontOfSize(fontSize))
	}
    
    func widthWithFont(font: UIFont) -> CGFloat {
        let size = CGSizeMake(CGFloat.max, CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.width
    }
	
}
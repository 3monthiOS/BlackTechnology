//
//  String+Size.swift
//  aha
//
//  Created by Cator Vee on 12/12/15.
//  Copyright © 2015 Ledong. All rights reserved.
//

import Foundation

extension String {
	
	func heightWithFontSize(_ fontSize: CGFloat, width: CGFloat) -> CGFloat {
		return heightWithFont(UIFont.systemFont(ofSize: fontSize), width: width)
	}
    
    func heightWithFont(_ font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
	
	func widthWithFontSize(_ fontSize: CGFloat) -> CGFloat {
		return widthWithFont(UIFont.systemFont(ofSize: fontSize))
	}
    
    func widthWithFont(_ font: UIFont) -> CGFloat {
        let size = CGSize(width: CGFloat.max, height: CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.width
    }
	
}

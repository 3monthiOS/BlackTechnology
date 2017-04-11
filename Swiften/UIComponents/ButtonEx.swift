//
//  ButtonEx.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

@IBDesignable
open class ButtonEx: UIButton {
	
	public enum ImagePosition: Int {
		case top, right, bottom, left
	}
	
	@IBInspectable
	open var gap: CGFloat = 0 {
		didSet {
			if gap < 0 {
				gap = 0
			}
			setNeedsLayout()
		}
	}
	
	open var imagePosition = ImagePosition.left {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable
	open var imagePosition_IB: Int {
		get {
			return imagePosition.rawValue
		}
		set {
			imagePosition = ImagePosition(rawValue: newValue) ?? .left
		}
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		guard let imageView = imageView, let titleLabel = titleLabel else {
			return
		}
		
		switch imagePosition {
		case .top:
			let width = frame.size.width
			let height = frame.size.height
			let imageHeight = imageView.frame.size.height
			let labelHeight = titleLabel.frame.size.height
			let margin = (height - imageHeight - labelHeight - gap) / 2
			imageView.center = CGPoint(x: width / 2, y: imageHeight / 2 + margin)
			titleLabel.frame = CGRect(x: 0, y: imageHeight + gap + margin, width: width, height: labelHeight)
			titleLabel.textAlignment = .center
		case .right:
			let width = frame.size.width
			let height = frame.size.height
			let imageWidth = imageView.frame.size.width
			let labelWidth = titleLabel.frame.size.width
			let labelHeight = titleLabel.frame.size.height
			let margin = max(0, (height - imageWidth - labelWidth - gap) / 2)
			let labelWidth2 = imageWidth + labelWidth + gap > width ? width - imageWidth - gap : labelWidth
			imageView.center = CGPoint(x: margin + labelWidth2 + gap + imageWidth / 2, y: height / 2)
			titleLabel.frame = CGRect(x: margin, y: (height - labelHeight) / 2, width: labelWidth2, height: labelHeight)
		case .bottom:
			let width = frame.size.width
			let height = frame.size.height
			let imageHeight = imageView.frame.size.height
			let labelHeight = titleLabel.frame.size.height
			let margin = (height - imageHeight - labelHeight - gap) / 2
			imageView.center = CGPoint(x: width / 2, y: imageHeight / 2 + margin + gap + labelHeight)
			titleLabel.frame = CGRect(x: 0, y: margin, width: width, height: labelHeight)
			titleLabel.textAlignment = .center
		case .left:
			let width = frame.size.width
			let height = frame.size.height
			let imageWidth = imageView.frame.size.width
			let labelWidth = titleLabel.frame.size.width
			let labelHeight = titleLabel.frame.size.height
			let margin = max(0, (height - imageWidth - labelWidth - gap) / 2)
			imageView.center = CGPoint(x: margin + imageWidth / 2, y: height / 2)
			let labelWidth2 = imageWidth + labelWidth + gap > width ? width - imageWidth - gap : labelWidth
			titleLabel.frame = CGRect(x: margin + imageWidth + gap, y: (height - labelHeight) / 2, width: labelWidth2, height: labelHeight)
		}
	}
	
}

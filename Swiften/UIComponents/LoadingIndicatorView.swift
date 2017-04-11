//
//  LoadingIndicatorView.swift
//  Swiften
//
//  Created by Cator Vee on 23/03/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import UIKit

public enum LoadingIndicatorViewStyle {
	case dark, light
}

public enum LoadingIndicatorViewTextStyle {
	case vertical, horizontal
}

open class LoadingIndicatorView: UIView {
	
	public var count = 0
	public var isLoading: Bool { return count > 0 }
	public var destinationView: UIView!
	public var style = LoadingIndicatorViewStyle.dark {
		didSet {
			setupSubviews()
		}
	}
	public var text: String? {
		didSet {
			if let text = text, !text.isEmpty {
				textLabel.text = text
				textLabel.isHidden = false
			} else {
				textLabel.isHidden = true
			}
			setNeedsLayout()
		}
	}
	public var textStyle = LoadingIndicatorViewTextStyle.horizontal {
		didSet {
			setNeedsLayout()
		}
	}
	
	public var indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
	public var textLabel = UILabel()
	
	public static let shared = LoadingIndicatorView(frame: .zero)
	
	public init(style: LoadingIndicatorViewStyle, destinationView: UIView? = nil) {
		super.init(frame: .zero)
		self.style = style
		self.destinationView = destinationView
		setupLoadingIndicatorView()
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupLoadingIndicatorView()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupLoadingIndicatorView()
	}
	
	open func setupSubviews() {
		switch style {
		case .dark:
			backgroundColor = UIColor.black.withAlphaComponent(0.4)
			indicatorView.activityIndicatorViewStyle = .white
			textLabel.textColor = UIColor.white
		case .light:
			backgroundColor = UIColor.white.withAlphaComponent(0.4)
			indicatorView.activityIndicatorViewStyle = .gray
			textLabel.textColor = UIColor.gray
		}
	}
	
	private func setupLoadingIndicatorView() {
		autoresizingMask = [.flexibleWidth, .flexibleHeight]
		textLabel.textAlignment = .center
		textLabel.lineBreakMode = .byTruncatingMiddle
		addSubview(textLabel)
		setupSubviews()
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		let width = bounds.size.width
		let height = bounds.size.height
		if let text = text, !text.isEmpty {
			let gap: CGFloat = 8
			let textMargin: CGFloat = 10
			let labelHeight = textLabel.font.lineHeight
			let widthWithoutMargins = width - textMargin * 2
			let indicatorWidth = indicatorView.frame.size.width
			let indicatorHeight = indicatorView.frame.size.height
			switch textStyle {
			case .vertical:
				textLabel.frame = CGRect(x: textMargin, y: height / 2, width: widthWithoutMargins, height: labelHeight)
				indicatorView.frame = CGRect(x: (width - indicatorWidth) / 2, y: height / 2 - indicatorHeight - gap, width: indicatorWidth, height: indicatorHeight)
			case .horizontal:
				let size = CGSize(width: widthWithoutMargins - indicatorWidth - gap, height: labelHeight)
				let paragraphStyle = NSMutableParagraphStyle()
				paragraphStyle.lineBreakMode = .byTruncatingMiddle
				let attributes = [
					NSFontAttributeName: textLabel.font,
					NSParagraphStyleAttributeName: paragraphStyle.copy()
				]
				let labelWidth = (text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.width
				let x = (width - labelWidth - indicatorWidth - gap) / 2
				indicatorView.center = CGPoint(x: x + indicatorWidth / 2, y: height / 2)
				textLabel.frame = CGRect(x: x + indicatorWidth + gap, y: (height - labelHeight) / 2, width: labelWidth, height: labelHeight)
			}
		} else {
			indicatorView.center = CGPoint(x: width / 2, y: height / 2)
		}
	}
	
	open func start(withLabel text: String? = nil) {
		count += 1
		if count == 1 {
			DispatchQueue.main.async { [weak self] in
				guard let view = self else { return }
				if let destinationView = view.destinationView ?? UIApplication.shared.keyWindow {
					view.frame = destinationView.bounds
					view.addSubview(view.indicatorView)
					view.indicatorView.startAnimating()
					destinationView.addSubview(view)
				}
			}
		}
		if let text = text {
			self.text = text
		}
	}
	
	open func stop() {
		count -= 1
		if count <= 0 {
			count = 0
			text = nil
			DispatchQueue.main.async { [weak self] in
				guard let view = self else { return }
				view.indicatorView.stopAnimating()
				view.indicatorView.removeFromSuperview()
				view.removeFromSuperview()
			}
		}
	}
}

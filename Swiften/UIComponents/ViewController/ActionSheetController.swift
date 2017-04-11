//
//  ActionSheetController.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

open class ActionSheetController: UIViewController {
	
	class PresentAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
		public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
			return 0.25
		}
		
		public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
			if let viewController = transitionContext.viewController(forKey: .to) as? ActionSheetController, let popupView = viewController.popupView {
				let containerView = transitionContext.containerView
				let frame = transitionContext.finalFrame(for: viewController)
				viewController.view.frame = frame
				viewController.view.backgroundColor = UIColor.clear
				containerView.addSubview(viewController.view)
				let height = popupView.bounds.size.height
				popupView.frame = popupView.frame.offsetBy(dx: 0, dy: height)
				
				let duration = transitionDuration(using: transitionContext)
				UIView.animate(withDuration: duration, animations: {
					viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
					popupView.frame = popupView.frame.offsetBy(dx: 0, dy: -height)
				}, completion: { finished in
					transitionContext.completeTransition(true)
				})
			} else {
				transitionContext.completeTransition(true)
			}
		}
	}
	
	class DismissAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
		public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
			return 0.25
		}
		
		public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
			if let viewController = transitionContext.viewController(forKey: .from) as? ActionSheetController {
				let duration = transitionDuration(using: transitionContext)
				UIView.animate(withDuration: duration, animations: {
					viewController.view.backgroundColor = UIColor.clear
					if let popupView = viewController.popupView {
						let height = popupView.frame.size.height
						popupView.frame = popupView.frame.offsetBy(dx: 0, dy: height)
					}
				}, completion: { finished in
					transitionContext.completeTransition(true)
				})
			} else {
				transitionContext.completeTransition(true)
			}
		}
	}
	
	var presentAnimatedTransitioning: PresentAnimatedTransitioning!
	var dismissAnimatedTransitioning: DismissAnimatedTransitioning!
	
	@IBOutlet open var popupView: UIView!
	var dismissButton: UIControl!
	
	open override var modalPresentationStyle: UIModalPresentationStyle {
		get { return .overFullScreen }
		set { /* nothing */ }
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		guard let popupView = popupView else {
			return
		}
		let width = view.frame.size.width
		let height = view.frame.size.height
		let popupViewHeight = popupView.frame.size.height
		dismissButton = UIControl(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height - popupViewHeight)))
		dismissButton.backgroundColor = .clear
		dismissButton.addTarget(self, action: #selector(dismissActionSheetController(_:)), for: .touchUpInside)
		dismissButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.insertSubview(dismissButton, at: 0)
		view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
		
		presentAnimatedTransitioning = PresentAnimatedTransitioning()
		dismissAnimatedTransitioning = DismissAnimatedTransitioning()
		transitioningDelegate = self
	}
	
	@IBAction public func dismissActionSheetController(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	open func dismiss(completion: (() -> Swift.Void)? = nil) {
		dismiss(animated: true, completion: completion)
	}
}

extension ActionSheetController: UIViewControllerTransitioningDelegate {
	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return presentAnimatedTransitioning
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return dismissAnimatedTransitioning
	}
}

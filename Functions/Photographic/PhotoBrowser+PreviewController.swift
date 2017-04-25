//
//  PhotoBrowser+PreviewController.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/3.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import UIKit
//import Swiften

extension PhotoBrowser {

	class PreviewController: APPviewcontroller, UIScrollViewDelegate, PhotoCropperDelegate, PhotoBrowserViewDelegate {

		var options: PhotoBrowserOptions!
		var backgroundColor = UIColor.black
		var gap: CGFloat = 20.0

		var currentIndex = 0
		weak var delegate: (PhotoBrowserDelegate & PhotoBrowserDataSource)!

		fileprivate var scrollView: UIScrollView!
        
		var isphotoAlbum = true
        
		fileprivate var previousView: View!
		fileprivate var currentView: View!
		fileprivate var nextView: View!

		fileprivate var copyButton: UIBarButtonItem! // 选取
//		private var originButton: UIBarButtonItem! // 原图
		fileprivate var cropButton: UIBarButtonItem! // 裁剪

		// MARK: - Init

		convenience init(delegate: (PhotoBrowserDelegate & PhotoBrowserDataSource)!, options: PhotoBrowserOptions, currentIndex: Int = 0) {
			self.init()
			self.delegate = delegate
			self.options = options
			self.currentIndex = currentIndex
		}

		func initView() -> View {
			let view = View()

			view.delegate = self

			return view
		}

		// MARK: - UIViewControll

		// override func loadView() {
		// self.view = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
		// self.view.frame = UIScreen.mainScreen().bounds
		// self.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		// }
        
        override var prefersStatusBarHidden:Bool{
            
            return true
            
        }
        
		override func viewDidLoad() {
			super.viewDidLoad()

			automaticallyAdjustsScrollViewInsets = false
			view.backgroundColor = backgroundColor

			// Init Scroll View
			scrollView = UIScrollView()
			scrollView.delegate = self
			scrollView.showsHorizontalScrollIndicator = false
			scrollView.showsVerticalScrollIndicator = false
			scrollView.isPagingEnabled = true
			view.addSubview(scrollView)

			// Init Views
			previousView = initView()
			scrollView.addSubview(previousView)
			currentView = initView()
			scrollView.addSubview(currentView)
			nextView = initView()
			scrollView.addSubview(nextView)

			switch options.style {
			case .preview: break
			case .singleSelection:
				initToolBArs()
			case .multiSelection:
				initToolBArs()
			}
			setupImageViewForIndex(currentIndex, force: true)
		}
		override func viewWillAppear(_ animated: Bool) {
			switch options.style {
			case .preview:
				setFullscreen(false, animated: false)
			case .singleSelection:
				setFullscreen(true, animated: true)
			case .multiSelection:
				setFullscreen(false, animated: true)
			}
            if isphotoAlbum {
                setFullscreen(false, animated: true)
            }
		}

		override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
			setFullscreen(true, animated: false)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }

		override var shouldAutorotate : Bool {
            super.shouldAutorotate
			return options.shouldSupportLandscape
		}

		override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
			return options.shouldSupportLandscape ? .all : .portrait
		}

		// MARK: - Layout

		override func viewWillLayoutSubviews() {
			super.viewWillLayoutSubviews()
			adjustFrames()
		}

		func adjustFrames() {
			let rect = view.bounds
			let width = gap + rect.width
			let count = delegate?.numberOfPhotosInPhotoBrowser(self) ?? 0
			scrollView.frame = CGRect(origin: rect.origin, size: CGSize(width: width, height: rect.height))
			scrollView.contentSize = CGSize(width: CGFloat(count) * width, height: rect.height)
			scrollView.contentOffset = CGPoint(x: CGFloat(currentIndex) * width, y: 0)

			adjustViews()
		}

		func adjustViews() {
			if let delegate = delegate {
				let count = delegate.numberOfPhotosInPhotoBrowser(self)
				let size = view.bounds.size
				adjustView(previousView, count: count, width: size.width, height: size.height)
				adjustView(currentView, count: count, width: size.width, height: size.height)
				adjustView(nextView, count: count, width: size.width, height: size.height)
				title = "\(currentIndex + 1) / \(count)"
			}
		}

		func adjustView(_ view: View, count: Int, width: CGFloat, height: CGFloat) {
			let index = view.tag
			view.isHidden = (index < 0 || index >= count)
			if !view.isHidden {
				view.frame = CGRect(x: CGFloat(index) * (width + gap), y: 0, width: width, height: height)

				if view.needsSetup {
					if let delegate = self.delegate {
						view.setup(delegate.photoBrowser(self, photoModelAtIndex: index))
					}
				}
			}
		}

		func setupImageViewForIndex(_ index: Int, force: Bool = false) {
			if index > currentIndex {
				let view = previousView
				previousView = currentView
				currentView = nextView
				nextView = view
				view?.reset()
				view?.tag = index + 1
			} else if index < currentIndex {
				let view = nextView
				nextView = currentView
				currentView = previousView
				previousView = view
				view?.reset()
				view?.tag = index - 1
			} else if force {
				previousView.tag = index - 1
				currentView.tag = index
				nextView.tag = index + 1
			} else {
				return
			}
			currentIndex = index

			adjustViews()
		}

		// MARK: - LDPhotoBrowserViewDelegate

		func photoViewDidSingleTap(_ view: PhotoBrowser.View) {
//			switch options.style {
//			case .Preview:
//				close()
//			case .SingleSelection:
//				setFullscreen(!fullscreen, animated: true)
//			case .MultiSelection:
//				setFullscreen(!fullscreen, animated: true)
//			}
            if isphotoAlbum {
                setFullscreen(!fullscreen, animated: true)
            }else{
                closeViewControllerAnimated(true)
            }
            
		}

		func photoViewDidUpdate(_ view: PhotoBrowser.View) {
			// self.adjustViews()
		}

		// MARK: Navbar Button Handler

		func handleCancelButtonTap(_ sender: UIButton) {
			closeViewControllerAnimated(true)
		}
		// MARK: TOOLBAR Inti
		func initToolBArs() {
            createBarButtonItemAtPosition(.right, Title: "取消", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(PreviewController.handleCancelButtonTap(_:)))
            // Init Toolbar
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            copyButton = UIBarButtonItem(title: "发送原图", style: .plain, target: self, action: #selector(PreviewController.handleConfirmButtonTap(_:)))
            cropButton = UIBarButtonItem(title: "裁剪", style: .plain, target: self, action: #selector(PreviewController.handleCropButtonTap(_:)))
            toolbarItems = [flexibleSpace,cropButton, flexibleSpace, flexibleSpace,flexibleSpace,copyButton,flexibleSpace]
		}
		// MARK: Toolbar Button Handler
		func handleConfirmButtonTap(_ sender: UIButton) {
				close()
		}

		func handleOriginButtonTap(_ sender: UIButton) {
			currentView.loadOriginImage()
            currentView.originImageLoaded = !currentView.originImageLoaded
		}

		func handleCropButtonTap(_ sender: UIButton) {
			currentView.loadOriginImage {
				guard let image = $0 else { return }
				// LDPhotoBrowser.showPhotoCropper(self, image: image)
				let controller = CropperViewController()
				controller.delegate = self
				controller.options = self.options
				controller.image = image
                controller.isTakerview = self.isphotoAlbum
				self.navigationController?.show(controller, sender: nil)
			}
		}

		func close() {
			guard let delegate = delegate else { return }
//			switch options.style {
//			case .Preview:
//				dismissViewControllerAnimated(true, completion: nil)
//			case .SingleSelection:
//				if options.requireCroppedImage {
//					currentView.loadOriginImage {
//						guard let image = $0 else { return }
//						let controller = CropperViewController()
//						controller.delegate = self
//						controller.options = self.options
//						controller.image = image
//						self.navigationController?.showViewController(controller, sender: nil)
//					}
//					return
//				}
//				dismissViewControllerAnimated(true, completion: nil)
//
//			case .MultiSelection:
//				if options.requireCroppedImage {
//					currentView.loadOriginImage {
//						guard let image = $0 else { return }
//						let controller = CropperViewController()
//						controller.delegate = self
//						controller.options = self.options
//						controller.image = image
//						self.navigationController?.showViewController(controller, sender: nil)
//					}
//					return
//				}
//				dismissViewControllerAnimated(true, completion: nil)

				let model: Model = currentView.model
				switch model {
				case .urls(_, _):
					currentView.loadOriginImage { image in
						if let image = image {
							delegate.photoBrowser(self, didSelect: .single(self.currentIndex, .image(image: image)))
						} else {
							delegate.photoBrowser(self, didSelect: .none)
						}
					}
				default:
					delegate.photoBrowser(self, didSelect: .single(currentIndex, currentView.model))
				}
            if isphotoAlbum {
                dismiss(animated: true, completion: nil)
            }else{
                closeViewControllerAnimated(true)
            }
//            toast("发送成功")
				return
//			}
//			delegate.photoBrowser(self, didSelect: .None)
		}

		// MARK: - UIScrollViewDelegate

		func scrollViewDidScroll(_ scrollView: UIScrollView) {
			let width = scrollView.bounds.size.width
			if width > 0 {
				let index = Int((scrollView.contentOffset.x + width * 0.5) / width)
				setupImageViewForIndex(index)
			}
		}

		func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
			let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
			setupImageViewForIndex(index)
		}

		// MARK: - LDPhotoCropperDelegate

		func photoCropper(_ photoCropper: PhotoBrowser.CropperViewController, didFinishCroppingImage croppedImage: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
			guard let delegate = delegate else { return }
			delegate.photoBrowser(self, didSelect: .single(currentIndex, Model.image(image: croppedImage)))
		}
	}

}

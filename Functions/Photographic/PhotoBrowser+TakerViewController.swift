//
//  PhotoBrowser+TakerViewController.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/4.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Swiften

extension PhotoBrowser {

	class TakerViewController: APPviewcontroller, PhotoBrowserViewDelegate, PhotoCropperDelegate {

		var options: PhotoBrowserOptions!
		var backgroundColor = UIColor.black

		fileprivate let captureSession = AVCaptureSession()
		fileprivate let stillImageOutput = AVCaptureStillImageOutput()
		fileprivate var input: AVCaptureDeviceInput!

		weak var delegate: PhotoBrowserDelegate!

		fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
		fileprivate var cameraPreview: UIView!
		fileprivate var stopButton: UIButton!
		fileprivate var takeButton: UIButton!
		fileprivate var FlipButton: UIButton!
		fileprivate var photoView: View!
        fileprivate var focusCursor: UIImageView!

		fileprivate var confirmButton: UIBarButtonItem!
		fileprivate var retakeButton: UIBarButtonItem!
		fileprivate var cropButton: UIBarButtonItem!

		fileprivate var viewInited = false
		fileprivate var isEditing = false
		fileprivate var buttonsHidden = false
		fileprivate var isUsingFrontFacingCameraBack = true
		fileprivate var isUseFlip = true
		fileprivate let buttonSize = CGSize(width: 60, height: 44)

		// MARK: - UIViewControll

        override var prefersStatusBarHidden:Bool {
            
            return true
            
        }
		override func viewDidLoad() {
			super.viewDidLoad()

			title = "相机"

			automaticallyAdjustsScrollViewInsets = false
			view.backgroundColor = backgroundColor
		}

		override func viewWillAppear(_ animated: Bool) {
			let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
			switch (authStatus) {
			case .notDetermined:
				AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { (granted) -> Void in
					async {
						if granted {
							self.initView()
						} else {
							self.dismiss(animated: true, completion: nil)
							toast("请在设置中打开访问相机的权限")
						}
					}
				}
			case .restricted, .denied:
				self.dismiss(animated: true, completion: nil)
				toast("请在设置中打开访问相机的权限")
			default:
				initView()
			}
		}

		func initView() {
			let rect = view.bounds

			photoView = View(frame: rect)
			photoView.delegate = self
			view.addSubview(photoView)

			cameraPreview = UIView(frame: rect)
			cameraPreview.backgroundColor = backgroundColor
			self.view.addSubview(self.cameraPreview)

			stopButton = UIButton()
			stopButton.setTitle("取消", for: UIControlState())
			stopButton.setTitleColor(rgb(128, 128, 128), for: .highlighted)
			stopButton.addTarget(self, action: #selector(TakerViewController.handleStopButtonTap(_:)), for: .touchUpInside)

			takeButton = UIButton()
			takeButton.setImage(UIImage(named: "Photo_1"), for: UIControlState())
			takeButton.setImage(UIImage(named: "Photo_2"), for: .highlighted)
			takeButton.clipsToBounds = true
			takeButton.layer.cornerRadius = 32
			takeButton.addTarget(self, action: #selector(TakerViewController.handleTakeButtonTap(_:)), for: .touchUpInside)

            focusCursor = UIImageView()
			focusCursor.layer.masksToBounds = true
            focusCursor.layer.borderColor = rgb(254, 209, 5).cgColor
            focusCursor.layer.borderWidth = 1
			focusCursor.alpha = 0

			FlipButton = UIButton()
			FlipButton.setImage(UIImage(named: "button_反向2"), for: UIControlState())
			FlipButton.setImage(UIImage(named: "button_反向1"), for: .highlighted)
			FlipButton.addTarget(self, action: #selector(TakerViewController.switchCameraSegmentedControlClick), for: .touchUpInside)

			initCaptureSession()

			// Init navbar
            createBarButtonItemAtPosition(.right, Title: "取消", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(TakerViewController.handleCancelButtonTap(_:)))

			// Init Toolbar
			let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
			confirmButton = UIBarButtonItem(title: "选取", style: .plain, target: self, action: #selector(TakerViewController.handleConfirmButtonTap(_:)))
			retakeButton = UIBarButtonItem(title: "重拍", style: .plain, target: self, action: #selector(TakerViewController.handleRetakeButtonTap(_:)))
			cropButton = UIBarButtonItem(title: "裁剪", style: .plain, target: self, action: #selector(TakerViewController.handleCropButtonTap(_:)))
			toolbarItems = [retakeButton, flexibleSpace, cropButton, flexibleSpace, confirmButton]

			viewInited = true
		}

		// MARK: - Layout

		override func viewWillLayoutSubviews() {
			super.viewWillLayoutSubviews()
			if viewInited {
				adjustFrames()
			}
		}

		func adjustFrames() {
			let rect = view.bounds

			if let _ = cameraPreview.superview {
				cameraPreview.frame = rect
				stopButton.frame = CGRect(origin: CGPoint(x: 10, y: rect.size.height - buttonSize.height - 30), size: buttonSize)
				takeButton.frame = CGRect(x: (rect.size.width - 64) * 0.5, y: rect.size.height - 64 - 20, width: 64, height: 64)
				FlipButton.frame = CGRect(x: (rect.size.width + 161) * 0.5, y: rect.size.height - 64 - 20, width: 84, height: 64)
				focusCursor.frame =  CGRect(x: 0, y: 0, width: 90, height: 90)
			}

			if let _ = photoView.superview {
				photoView.frame = rect
			}
		}

		// MARK: Capture Session

		func initCaptureSession() {
			setFullscreen(true, animated: true)
			async({
				var devices = AVCaptureDevice.devices()
				if self.isUsingFrontFacingCameraBack {
					devices = AVCaptureDevice.devices().filter { $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.back }
				} else {
					devices = AVCaptureDevice.devices().filter { $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.front }
				}
				if let captureDevice = devices.first as? AVCaptureDevice {

					do {
						self.input = try AVCaptureDeviceInput(device: captureDevice)
					} catch let error as NSError {
						Log.error(error.localizedDescription)
						self.view.makeToast(error.localizedDescription)
						return false
					}
					self.initUIdata()
					return true
				}
				return false
			}) {
				guard let success = $0 as? Bool where success else {
					toast("未找到可用设备")
					self.dismiss(animated: true, completion: nil)
					return
				}
                self.cameraPreview.layer.addSublayer(self.previewLayer)
                self.cameraPreview.addSubview(self.focusCursor)
                self.cameraPreview.addSubview(self.stopButton)
				self.cameraPreview.addSubview(self.takeButton)
				self.cameraPreview.addSubview(self.FlipButton)
				
				self.addGenstureRecognizer()
				self.captureSession.startRunning()
			}
		}

		func stopCaptureSessioin() {
			self.captureSession.stopRunning()
			self.captureSession.removeInput(self.input)
			self.captureSession.removeOutput(self.stillImageOutput)
			self.cameraPreview.removeFromSuperview()
			self.previewLayer.removeFromSuperlayer()
			self.stopButton.removeFromSuperview()
			self.takeButton.removeFromSuperview()
			self.FlipButton.removeFromSuperview()
			self.focusCursor.removeFromSuperview()
			self.setFullscreen(false, animated: true)
		}
		func initUIdata() {
			let rect = view.bounds
			if isUseFlip {
				self.captureSession.addInput(self.input)
			}
			self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto

			self.stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
			if self.captureSession.canAddOutput(self.stillImageOutput) {
				self.captureSession.addOutput(self.stillImageOutput)
			}

			self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
			if let previewLayer = self.previewLayer {
				previewLayer.bounds = rect
				previewLayer.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
				previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
			}
			self.flashButtonClick()
		}
		// MARK: Camera Button Handler

		func handleStopButtonTap(_ sender: UIButton) {
			self.stopCaptureSessioin()
			if photoView.model == nil {
				self.dismiss(animated: true, completion: nil)
			}
		}

		func handleTakeButtonTap(_ sender: UIButton) {
			guard captureSession.isRunning else { return }
			self.stopButton.removeFromSuperview()
			self.takeButton.removeFromSuperview()
			self.FlipButton.removeFromSuperview()
			self.focusCursor.removeFromSuperview()
			if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
				stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
					(imageDataSampleBuffer, error) -> Void in
					let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
					let img = UIImage(data: imageData)
					img?.contentType = .JPEG

					self.stopCaptureSessioin()

					self.photoView.setup(.image(image: img!))
					self.photoView.setNeedsLayout()
					self.isEditing = true
				}
			}
		}

		// MARK: Navbar Button Handler

		func handleCancelButtonTap(_ sender: UIButton) {
			dismiss(animated: true, completion: nil)
		}

		// MARK: Toolbar Button Handler

		func handleConfirmButtonTap(_ sender: UIButton) {
			close()
		}

		func handleRetakeButtonTap(_ sender: UIButton) {
			view.addSubview(cameraPreview)
			initCaptureSession()
		}

		func handleCropButtonTap(_ sender: UIButton) {
			photoView.loadOriginImage {
				guard let image = $0 else { return }
				// LDPhotoBrowser.showPhotoCropper(self, image: image)
				let controller = CropperViewController()
				controller.delegate = self
				controller.options = self.options
				controller.image = image
                controller.isTakerview = true
				self.navigationController?.show(controller, sender: nil)
			}
		}

		func close() {
			let model: Model = photoView.model
			switch model {
			case .image(let image):
				if options.requireCroppedImage {
					photoView.loadOriginImage {
						guard let image = $0 else { return }
						let controller = CropperViewController()
						controller.delegate = self
						controller.options = self.options
						controller.image = image
						self.navigationController?.show(controller, sender: nil)
					}
					return
				}

				delegate.photoBrowser(self, didSelect: .single(-1, .image(image: image)))
			default: break
			}

			self.dismiss(animated: true, completion: nil)
		}

		// MARK: - LDPhotoCropperDelegate

		func photoCropper(_ photoCropper: PhotoBrowser.CropperViewController, didFinishCroppingImage croppedImage: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
			guard let delegate = delegate else { return }
			delegate.photoBrowser(self, didSelect: .single(-1, .image(image: croppedImage)))
		}

		// MARK: - LDPhotoBrowserViewDelegate

		func photoViewDidSingleTap(_ view: PhotoBrowser.View) {
			if isEditing {
				setFullscreen(!fullscreen, animated: true)
			}
		}

		func photoViewDidUpdate(_ view: PhotoBrowser.View) {
			// nothing
		}
		// MARK: - 设置闪光灯
		func flashButtonClick() {
			let devices = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
			do {
				try devices.lockForConfiguration()
			} catch _ {
				toast("锁定异常")
			}
			if devices.hasFlash {
				if isUsingFrontFacingCameraBack {
					devices.flashMode = AVCaptureFlashMode.auto
				} else {
					devices.flashMode = AVCaptureFlashMode.off
				}
			}
			devices.unlockForConfiguration()
		}
		// MARK: - 设置镜头翻转
		func switchCameraSegmentedControlClick() {
			isUseFlip = false
			async({ () -> AnyObject! in
				var devices = AVCaptureDevice.devices()
				if self.isUsingFrontFacingCameraBack {
					devices = AVCaptureDevice.devices().filter { $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.front }
				} else {
					devices = AVCaptureDevice.devices().filter { $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.back }
				}
                self.previewLayer.session.beginConfiguration()
				let input: AVCaptureInput?
				if let captureDevice = devices.first as? AVCaptureDevice {
					do {
						input = try AVCaptureDeviceInput(device: captureDevice)
					} catch let error as NSError {
						Log.error(error.localizedDescription)
						self.view.makeToast(error.localizedDescription)
						return false
					}
					for oldInput: AVCaptureInput in self.previewLayer.session.inputs as! [AVCaptureInput] {
						self.previewLayer.session.removeInput(oldInput)
					}
					self.previewLayer.session.addInput(input)
                    self.previewLayer.session.commitConfiguration()
					return true
				}
				return false
			}) { (isok) in
				self.view.hideToastActivity()
				guard let success = isok as? Bool where success else {
					toast("旋转失败")
					return
				}
				self.isUsingFrontFacingCameraBack = !self.isUsingFrontFacingCameraBack
				self.flashButtonClick()
			}
		}

		func focusWithMode(_ focusMode: AVCaptureFocusMode, exposureMode: AVCaptureExposureMode, point: CGPoint) {
			let captureDevice = self.input.device
			do {
				try captureDevice.lockForConfiguration()
			} catch {
				Log.info("上锁失败")
			}
			if captureDevice.isFocusModeSupported(focusMode) {
				captureDevice.focusMode = AVCaptureFocusMode.autoFocus
			}
			if captureDevice.isFocusPointOfInterestSupported {
				captureDevice.focusPointOfInterest = point
			}
			if captureDevice.isExposureModeSupported(exposureMode) {
				captureDevice.exposureMode = AVCaptureExposureMode.autoExpose
			}
			if captureDevice.isExposurePointOfInterestSupported {
				captureDevice.exposurePointOfInterest = point
			}
            captureDevice.unlockForConfiguration()
            
		}
		func addGenstureRecognizer() {
			let tap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
			self.cameraPreview.addGestureRecognizer(tap)
		}
		func setFocusCursorWithPoint(_ point: CGPoint) {
			self.focusCursor.center = point
			self.focusCursor.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
			self.focusCursor.alpha = 1.0
			UIView.animate(withDuration: 0.4, animations: {
				self.focusCursor.transform = CGAffineTransform.identity
			}, completion: { (isok) in
				if isok {
					self.focusCursor.alpha = 0
				}
			}) 
		}
		func tapScreen(_ tapGesture: UITapGestureRecognizer) {
			let point = tapGesture.location(in: self.cameraPreview)
			let cameraPoint = self.previewLayer.captureDevicePointOfInterest(for: point)
			self.setFocusCursorWithPoint(point)
			self.focusWithMode(AVCaptureFocusMode.autoFocus, exposureMode: AVCaptureExposureMode.autoExpose, point: cameraPoint)
		}
	}

}

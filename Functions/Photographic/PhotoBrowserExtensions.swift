//
//  PhotoBrowserExtensions.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/3.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import Photos
import Swiften
import Alamofire
import AlamofireImage
import MobileCoreServices

// MARK: Style
extension PhotoBrowser {
    
    enum Style {
        case Preview //预览
        case SingleSelection  // 单张
        case MultiSelection  // 多张
    }
}

// MARK: Model
extension PhotoBrowser {
    enum Model {
        case Urls(url: String, preview: String)
        case Asset(asset: PHAsset)
        case Image(image: UIImage)
        
        //		static func createWithUrls(url: String, preview: String! = nil) -> Model {
        //			let imageUrl = NSURL(string: url)!
        //			let previewUrl = preview == nil ? imageUrl : NSURL(string: preview)
        //			return Model.Urls(url: imageUrl, preview: previewUrl ?? imageUrl)
        //		}
    }
}
// MARK: Selection
extension PhotoBrowser {
    
    enum Selection {
        case None
        case Single(Int, Model)
        case Multi([Int], [Model])
        
        func getImage(completion: UIImage? -> Void) {
            switch self {
            case .None: break
            case .Multi( _, let models):
                for model in models {
                    switch model {
                    case .Asset(let asset):
                        UIViewController.topViewController?.view.makeToastActivity(ToastPosition.Center)
                        PHImageManager.defaultManager().requestImageDataForAsset(asset, options: nil) { (data, dataUTI, orientation, info) -> Void in
                            if data != nil {
                                let contentType = UIImage.ContentType.contentTypeWithImageData(data)
                                let img = UIImage(data: data!)
                                img?.contentType = contentType
                                completion(img)
                                
                            } else {
                                completion(nil)
                            }
                            UIViewController.topViewController?.view.hideToastActivity()
                        }
                        return
                    case .Image(let image):
                        completion(image)
                        return
                    case .Urls(let url, _):
                        UIViewController.topViewController?.view.makeToastActivity(ToastPosition.Center)
                        NetworkManager.sharedInstace.defaultManager.request(.GET, url).responseImage { (response: Alamofire.Response<AlamofireImage.Image, NSError>) in
                            switch response.result {
                            case .Success(let image):
                                image.contentType = UIImage.ContentType.contentType(mimeType: response.response?.MIMEType)
                                completion(image)
                                return
                            case .Failure(let error):
                                Log.error(error)
                            }
                            UIViewController.topViewController?.view.hideToastActivity()
                        }
                    }
                }
            case .Single(_, let model):
                switch model {
                case .Asset(let asset):
                    UIViewController.topViewController?.view.makeToastActivity(ToastPosition.Center)
                    PHImageManager.defaultManager().requestImageDataForAsset(asset, options: nil) { (data, dataUTI, orientation, info) -> Void in
                        if data != nil {
                            let contentType = UIImage.ContentType.contentTypeWithImageData(data)
                            let img = UIImage(data: data!)
                            img?.contentType = contentType
                            completion(img)
                            
                        } else {
                            completion(nil)
                        }
                        UIViewController.topViewController?.view.hideToastActivity()
                    }
                    return
                case .Image(let image):
                    completion(image)
                    return
                case .Urls(let url, _):
                    UIViewController.topViewController?.view.makeToastActivity(ToastPosition.Center)
                    NetworkManager.sharedInstace.defaultManager.request(.GET, url).responseImage { (response: Alamofire.Response<AlamofireImage.Image, NSError>) in
                        switch response.result {
                        case .Success(let image):
                            image.contentType = UIImage.ContentType.contentType(mimeType: response.response?.MIMEType)
                            completion(image)
                            return
                        case .Failure(let error):
                            Log.error(error)
                        }
                        UIViewController.topViewController?.view.hideToastActivity()
                    }
                }
                completion(nil)
            }
        }
    }
    
}

// MARK: getLocString
func getLocString(key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: comment)
}

// MARK: PickerViewController
extension PhotoBrowser {
    
    static var lastAlbum: PHAssetCollection?
    
    class PickerViewController: UINavigationController, UIGestureRecognizerDelegate {
        
        weak var pickerDelegate: PhotoBrowserDelegate!
        var options: PhotoBrowserOptions!
        
        convenience init(delegate: PhotoBrowserDelegate!, options: PhotoBrowserOptions) {
            self.init()
            self.pickerDelegate = delegate
            self.options = options
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = UIColor.whiteColor()
        }
        
        override func viewWillAppear(animated: Bool) {
            PHPhotoLibrary.requestAuthorization { (status) -> Void in
                async {
                    if status == .Denied || status == .Restricted {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        toast("请在设置中打开访问相片的权限")
                    } else {
                        let albumTableViewController = AlbumTableViewController(delegate: self)
                        albumTableViewController.title = NSLocalizedString("相册列表", comment: "相册")
                        let gridViewController = GridViewController.getInstance(self)
                        self.viewControllers = [albumTableViewController, gridViewController]
                    }
                }
            }
        }
        
    }
}

// MARK: GridCell
extension PhotoBrowser {
    
    class GridCell: UICollectionViewCell {
        
        private var asset: PHAsset!
        private var imageView: UIImageView!
        
        private var inited = false
        
        func setAsset(asset: PHAsset) {
            self.asset = asset
            
            if !inited {
                inited = true
                
                imageView = UIImageView(frame: self.bounds)
                self.addSubview(imageView)
            }
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .HighQualityFormat
            options.resizeMode = .Exact
            let size = CGSize(width: self.bounds.size.width * SCREEN_SCALE, height: self.bounds.size.height * SCREEN_SCALE)
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: size, contentMode: .AspectFill, options: options) { (result, info) -> Void in
                if let image = result {
                    self.imageView.image = image
                }
            }
        }
        
    }
    
}

// MARK: UIViewController
extension UIViewController {
    
    class GridCell: UICollectionViewCell {
        
        private var asset: PHAsset!
        private var imageView: UIImageView!
        
        private var inited = false
        
        func setAsset(asset: PHAsset) {
            self.asset = asset
            
            if !inited {
                inited = true
                
                imageView = UIImageView(frame: self.bounds)
                self.addSubview(imageView)
            }
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .HighQualityFormat
            options.resizeMode = .Exact
            let size = CGSize(width: self.bounds.size.width * SCREEN_SCALE, height: self.bounds.size.height * SCREEN_SCALE)
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: size, contentMode: .AspectFill, options: options) { (result, info) -> Void in
                if let image = result {
                    self.imageView.image = image
                }
            }
        }
        
    }
    
    // 设置状态栏
    var fullscreen: Bool {
        get { return navigationController?.navigationBarHidden ?? false }
        set {
            setFullscreen(newValue, animated: false)
        }
    }
    
    func setFullscreen(flag: Bool, animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(flag, withAnimation: animated ? .Fade : .None)
        navigationController?.setNavigationBarHidden(flag, animated: animated)
        navigationController?.setToolbarHidden(flag, animated: animated)
    }
}

// MARK: PHAsset
extension PHAsset {
    
    static func fetchImageAssetsInAssetCollection(assetCollection: PHAssetCollection, fetchLimit: Int = 0) -> PHFetchResult {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
        if #available(iOS 9.0, *) {
            options.fetchLimit = fetchLimit
        }
        return PHAsset.fetchAssetsInAssetCollection(assetCollection, options: options)
    }
    
}



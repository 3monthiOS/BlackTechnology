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
        case preview //预览
        case singleSelection  // 单张
        case multiSelection  // 多张
    }
}

// MARK: Model
extension PhotoBrowser {
    enum Model {
        case urls(url: String, preview: String)
        case asset(asset: PHAsset)
        case image(image: UIImage)
        
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
        case none
        case single(Int, Model)
        case multi([Int], [Model])
        
        func getImage(_ completion: (UIImage?) -> Void) {
            switch self {
            case .none: break
            case .multi( _, let models):
                for model in models {
                    switch model {
                    case .asset(let asset):
                        UIViewController.topViewController?.view.makeToastActivity(ToastPosition.Center)
                        PHImageManager.default().requestImageData(for: asset, options: nil) { (data, dataUTI, orientation, info) -> Void in
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
                    case .image(let image):
                        completion(image)
                        return
                    case .urls(let url, _):
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
            case .single(_, let model):
                switch model {
                case .asset(let asset):
                    UIViewController.topViewController?.view.makeToastActivity(ToastPosition.Center)
                    PHImageManager.default().requestImageData(for: asset, options: nil) { (data, dataUTI, orientation, info) -> Void in
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
                case .image(let image):
                    completion(image)
                    return
                case .urls(let url, _):
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
func getLocString(_ key: String, comment: String = "") -> String {
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
            
            view.backgroundColor = UIColor.white
        }
        
        override func viewWillAppear(_ animated: Bool) {
            PHPhotoLibrary.requestAuthorization { (status) -> Void in
                async {
                    if status == .denied || status == .restricted {
                        self.dismiss(animated: true, completion: nil)
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
        
        fileprivate var asset: PHAsset!
        fileprivate var imageView: UIImageView!
        
        fileprivate var inited = false
        
        func setAsset(_ asset: PHAsset) {
            self.asset = asset
            
            if !inited {
                inited = true
                
                imageView = UIImageView(frame: self.bounds)
                self.addSubview(imageView)
            }
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            let size = CGSize(width: self.bounds.size.width * SCREEN_SCALE, height: self.bounds.size.height * SCREEN_SCALE)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { (result, info) -> Void in
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
        
        fileprivate var asset: PHAsset!
        fileprivate var imageView: UIImageView!
        
        fileprivate var inited = false
        
        func setAsset(_ asset: PHAsset) {
            self.asset = asset
            
            if !inited {
                inited = true
                
                imageView = UIImageView(frame: self.bounds)
                self.addSubview(imageView)
            }
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            let size = CGSize(width: self.bounds.size.width * SCREEN_SCALE, height: self.bounds.size.height * SCREEN_SCALE)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { (result, info) -> Void in
                if let image = result {
                    self.imageView.image = image
                }
            }
        }
        
    }
    
    // 设置状态栏
    var fullscreen: Bool {
        get { return navigationController?.isNavigationBarHidden ?? false }
        set {
            setFullscreen(newValue, animated: false)
        }
    }
    
    func setFullscreen(_ flag: Bool, animated: Bool) {
        UIApplication.shared.setStatusBarHidden(flag, with: animated ? .fade : .none)
        navigationController?.setNavigationBarHidden(flag, animated: animated)
        navigationController?.setToolbarHidden(flag, animated: animated)
    }
}

// MARK: PHAsset
extension PHAsset {
    
    static func fetchImageAssetsInAssetCollection(_ assetCollection: PHAssetCollection, fetchLimit: Int = 0) -> PHFetchResult {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        if #available(iOS 9.0, *) {
            options.fetchLimit = fetchLimit
        }
        return PHAsset.fetchAssets(in: assetCollection, options: options)
    }
    
}



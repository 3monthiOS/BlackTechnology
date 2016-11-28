//
//  PhotoBrowserDelegate.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/3.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation


protocol PhotoBrowserDataSource : NSObjectProtocol {
    // 数据源
    func photoBrowser(photoBrowser: PhotoBrowser.PreviewController, photoModelAtIndex index: Int) -> PhotoBrowser.Model
    func numberOfPhotosInPhotoBrowser(photoBrowser: PhotoBrowser.PreviewController) -> Int
    
}

protocol PhotoBrowserDelegate : NSObjectProtocol {
    //
    func photoBrowser(viewController: UIViewController, didSelect selection: PhotoBrowser.Selection)
    
}

protocol PhotoBrowserViewDelegate : NSObjectProtocol {
    
    func photoViewDidSingleTap(view: PhotoBrowser.View)
    func photoViewDidUpdate(view: PhotoBrowser.View)
    
}

protocol PhotoCropperDelegate : NSObjectProtocol {
    
    func photoCropper(photoCropper: PhotoBrowser.CropperViewController, didFinishCroppingImage croppedImage: UIImage, transform: CGAffineTransform, cropRect: CGRect)
    
}
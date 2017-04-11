//
//  PhotoBrowserOptions.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/3.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation

class PhotoBrowserOptions {
    
    var requireCroppedImage = false             // 是否必须裁剪图片
    var keepingCropAspectRatio = false          // 是否保持固定的宽高比
    var cropAspectRatio: CGFloat = -1           // 宽高比，默认值-1代表原图比例
    var shouldSupportLandscape = true           // 是否支持横屏显示
    var style = PhotoBrowser.Style.preview    // 图片浏览的样式
    
    static func photoBrowserOptionsForSingleSelection() -> PhotoBrowserOptions {
        let options = PhotoBrowserOptions()
        options.style = .singleSelection
        return options
    }
    static func photoBrowserOptionsForSingleMultiSelection() -> PhotoBrowserOptions {
        let options = PhotoBrowserOptions()
        options.style = .multiSelection
        return options
    }
}

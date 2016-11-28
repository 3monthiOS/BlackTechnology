//
//  AlbumTableViewController.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/3.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import Photos
import Swiften

extension PhotoBrowser {
    
    class AlbumTableViewController: UITableViewController {
        
        let cellReuseIdentifier = "LDPhotoView.AlbumTableViewCell"
        
        var albums = [PHAssetCollection]()
        
        weak var delegate: UIViewController!
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        init(delegate: UIViewController) {
            super.init(style: .Plain)
            self.delegate = delegate
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Setup View
            self.title = "相册"
            self.createBarButtonItemAtPosition(.Right, Title: "取消", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(AlbumTableViewController.cancelAction(_:)))
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
            tableView.tableFooterView = UIView(frame: CGRectZero)
            
            loadAlbums()
        }
        
        func cancelAction(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        func loadAlbums() {
            PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .SmartAlbumUserLibrary, options: nil)
                .enumerateObjectsUsingBlock { (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        if PHAsset.fetchImageAssetsInAssetCollection(collection).count > 0 {
                            self.albums.append(collection)
                        }
                    }
            }
            PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .AlbumMyPhotoStream, options: nil)
                .enumerateObjectsUsingBlock { (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        self.albums.append(collection)
                    }
            }
            PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .SmartAlbumRecentlyAdded, options: nil)
                .enumerateObjectsUsingBlock { (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        if PHAsset.fetchImageAssetsInAssetCollection(collection).count > 0 {
                            self.albums.append(collection)
                        }
                    }
            }
            PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .Any, options: nil)
                .enumerateObjectsUsingBlock { (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        switch collection.assetCollectionSubtype {
                        case .SmartAlbumUserLibrary, .SmartAlbumRecentlyAdded:
                            break
                        default:
                            if PHAsset.fetchImageAssetsInAssetCollection(collection).count > 0 {
                                self.albums.append(collection)
                            }
                        }
                    }
            }
            PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .AlbumSyncedAlbum, options: nil)
                .enumerateObjectsUsingBlock { (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        if collection.estimatedAssetCount > 0 {
                            self.albums.append(collection)
                        }
                    }
            }
            PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .AlbumRegular, options: nil)
                .enumerateObjectsUsingBlock { (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        if collection.estimatedAssetCount > 0 {
                            self.albums.append(collection)
                        }
                    }
            }
        }
        
        func buildAlbumTitle(album: PHAssetCollection) -> NSAttributedString {
            let albumTitle = album.localizedTitle ?? ""
            var count = album.estimatedAssetCount
            if count == Int.max {
                count = PHAsset.fetchImageAssetsInAssetCollection(album).count
            }
            let numberString = " (\(count))"
            let title = "\(albumTitle)\(numberString)"
            let attributedString = NSMutableAttributedString(string: title)
            attributedString.setAttributes([
                NSFontAttributeName: UIFont.systemFontOfSize(16.0),
                NSForegroundColorAttributeName: UIColor.blackColor()
                ], range: NSMakeRange(0, albumTitle.characters.count))
            attributedString.setAttributes([
                NSFontAttributeName: UIFont.systemFontOfSize(16.0),
                NSForegroundColorAttributeName: UIColor.grayColor()
                ], range: NSMakeRange(albumTitle.characters.count, numberString.characters.count))
            return attributedString
        }
        
        // MARK - UITableViewDelegate
        override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 64
        }
        
        override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 64
        }
        
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let album = albums[indexPath.row]
            PhotoBrowser.lastAlbum = album
            
            let gridViewController = GridViewController.getInstance(delegate)
            navigationController?.pushViewController(gridViewController, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        // MARK - UITableViewDataSource
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return albums.count
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let album = albums[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.attributedText = buildAlbumTitle(album)
            
            cell.imageView?.image = UIImage(named: "Placeholder_image")
            
            let fetchResult = PHAsset.fetchImageAssetsInAssetCollection(album, fetchLimit: 1)
            let asset = fetchResult.firstObject as! PHAsset
            let options = PHImageRequestOptions()
            options.deliveryMode = .HighQualityFormat
            options.resizeMode = .Exact
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSize(width: 128, height: 128), contentMode: .AspectFill, options: options) { (result, info) -> Void in
                if let image = result {
                    cell.imageView?.image = image
                }
            }
            
            return cell
        }
    }
    
}

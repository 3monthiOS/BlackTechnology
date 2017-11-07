//
//  AlbumTableViewController.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/3.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import Photos
//import Swiften

extension PhotoBrowser {
    
    class AlbumTableViewController: UITableViewController {
        
        let cellReuseIdentifier = "LDPhotoView.AlbumTableViewCell"
        
        var albums = [PHAssetCollection]()
        
        weak var delegate: UIViewController!
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        init(delegate: UIViewController) {
            super.init(style: .plain)
            self.delegate = delegate
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Setup View
            self.title = "相册"
            let _ = self.createBarButtonItemAtPosition(.right, Title: "取消", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(AlbumTableViewController.cancelAction(_:)))
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
            tableView.tableFooterView = UIView(frame: CGRect.zero)
            
            loadAlbums()
        }
        
        func cancelAction(_ sender: AnyObject) {
            Notifications.hidedAndShowTabbaritem.post()
            self.dismiss(animated: true, completion: nil)
        }
        
        func loadAlbums() {
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
                .enumerateObjects({ (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        if PHAsset.fetchImageAssetsInAssetCollection(collection).count > 0 {
                            self.albums.append(collection)
                        }
                    }
                })
            PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
                .enumerateObjects({ (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        self.albums.append(collection)
                    }
                })
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
                .enumerateObjects({ (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        if PHAsset.fetchImageAssetsInAssetCollection(collection).count > 0 {
                            self.albums.append(collection)
                        }
                    }
                })
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
                .enumerateObjects({ (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        switch collection.assetCollectionSubtype {
                        case .smartAlbumUserLibrary, .smartAlbumRecentlyAdded:
                            break
                        default:
                            if PHAsset.fetchImageAssetsInAssetCollection(collection).count > 0 {
                                self.albums.append(collection)
                            }
                        }
                    }
                })
            PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumSyncedAlbum, options: nil)
                .enumerateObjects({ (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        if collection.estimatedAssetCount > 0 {
                            self.albums.append(collection)
                        }
                    }
                })
            PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
                .enumerateObjects({ (obj, index, stop) -> Void in
                    if let collection = obj as? PHAssetCollection {
                        if collection.estimatedAssetCount > 0 {
                            self.albums.append(collection)
                        }
                    }
                })
        }
        
        func buildAlbumTitle(_ album: PHAssetCollection) -> NSAttributedString {
            let albumTitle = album.localizedTitle ?? ""
            var count = album.estimatedAssetCount
            if count == Int.max {
                count = PHAsset.fetchImageAssetsInAssetCollection(album).count
            }
            let numberString = " (\(count))"
            let title = "\(albumTitle)\(numberString)"
            let attributedString = NSMutableAttributedString(string: title)
            attributedString.setAttributes([
                NSFontAttributeName: UIFont.systemFont(ofSize: 16.0),
                NSForegroundColorAttributeName: UIColor.black
                ], range: NSMakeRange(0, albumTitle.characters.count))
            attributedString.setAttributes([
                NSFontAttributeName: UIFont.systemFont(ofSize: 16.0),
                NSForegroundColorAttributeName: UIColor.gray
                ], range: NSMakeRange(albumTitle.characters.count, numberString.characters.count))
            return attributedString
        }
        
        // MARK - UITableViewDelegate
        override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 64
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 64
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let album = albums[indexPath.row]
            PhotoBrowser.lastAlbum = album
            
            let gridViewController = GridViewController.getInstance(delegate)
            navigationController?.pushViewController(gridViewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        // MARK - UITableViewDataSource
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return albums.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let album = albums[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.attributedText = buildAlbumTitle(album)
            
            cell.imageView?.image = UIImage(named: "Placeholder_image")
            
            let fetchResult = PHAsset.fetchImageAssetsInAssetCollection(album, fetchLimit: 1)
            let asset = fetchResult.firstObject as! PHAsset
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 128, height: 128), contentMode: .aspectFill, options: options) { (result, info) -> Void in
                if let image = result {
                    cell.imageView?.image = image
                }
            }
            
            return cell
        }
    }
    
}

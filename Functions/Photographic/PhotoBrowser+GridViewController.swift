//
//  PhotoBrowser+GridViewController.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/3.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import Photos


extension PhotoBrowser {
    
    class GridViewController: UICollectionViewController, PhotoBrowserDelegate, PhotoBrowserDataSource {
        
        let reuseIdentifier = "LDPhotoBrowser.GridCell"
        
        var album: PHAssetCollection?
        
        var assets: PHFetchResult<AnyObject>!
        
        weak var delegate: UIViewController!
        
        static func getInstance(_ delegate: UIViewController) -> GridViewController {
            let space: CGFloat = 2
            let width = (min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - space * 5) / 4
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = space
            layout.minimumInteritemSpacing = space
            layout.itemSize = CGSize(width: width, height: width)
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
            let controller = GridViewController(collectionViewLayout: layout)
            controller.delegate = delegate
            controller.album = PhotoBrowser.lastAlbum
            return controller
        }
        
        // MARK: - UIViewController
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Register cell classes
            self.collectionView!.register(GridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            
            // Do any additional setup after loading the view.
            self.title = album?.localizedTitle ?? "相片"
            
            collectionView?.backgroundColor = UIColor.white
            let _ = self.createBarButtonItemAtPosition(.right, Title: "取消", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(GridViewController.cancelAction(_:)))
//            self.createBarButtonItemAtPosition(.Right, text: "取消", action: #selector(GridViewController.cancelAction(_:)))
            
            // Init Collection View
            collectionView?.alwaysBounceVertical = true
            collectionView?.showsHorizontalScrollIndicator = true
            collectionView?.allowsSelection = true
            
            // Init Data
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            if let album = album {
                options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                assets = PHAsset.fetchAssets(in: album, options: options) as! PHFetchResult<AnyObject>
            } else {
                assets = PHAsset.fetchAssets(with: .image, options: options) as! PHFetchResult<AnyObject>
            }
            collectionView?.reloadData()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            navigationController?.setNavigationBarHidden(false, animated: animated)
            navigationController?.setToolbarHidden(true, animated: animated)
        }
        
        func cancelAction(_ sender: AnyObject) {
            self.dismiss(animated: true, completion: nil)
        }
        
        /*
         // MARK: - Navigation
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         // Get the new view controller using [segue destinationViewController].
         // Pass the selected object to the new view controller.
         }
         */
        
        // MARK: - UICollectionViewDataSource
        
        override func numberOfSections(in collectionView: UICollectionView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of items
            return assets == nil ? 0 : assets.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GridCell
            
            let asset = assets.object(at: indexPath.row) as! PHAsset
            
            // Configure the cell
            cell.setAsset(asset)
            
            return cell
        }
        
        // MARK: - UICollectionViewDelegate
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let delegate = delegate as? PickerViewController else { return }
            let controller = PreviewController(delegate: self, options: delegate.options, currentIndex: indexPath.row)
            controller.isphotoAlbum = true
            navigationController?.pushViewController(controller, animated: true)
        }
        
        /*
         // Uncomment this method to specify if the specified item should be highlighted during tracking
         override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment this method to specify if the specified item should be selected
         override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
         override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
         return false
         }
         
         override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
         return false
         }
         
         override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
         
         }
         */
        
        // MARK: LDPhotoBrowserDataSource
        
        func photoBrowser(_ photoBrowser: PhotoBrowser.PreviewController, photoModelAtIndex index: Int) -> PhotoBrowser.Model {
            let asset = assets[index] as! PHAsset
            return PhotoBrowser.Model.asset(asset: asset)
        }
        
        func numberOfPhotosInPhotoBrowser(_ photoBrowser: PhotoBrowser.PreviewController) -> Int {
            return assets.count
        }
        
        // MARK: LDPhotoBrowserDelegate
        
        func photoBrowser(_ viewController: UIViewController, didSelect selection: PhotoBrowser.Selection) {
            if let delegate = delegate as? PickerViewController {
                if let pickerDelegate = delegate.pickerDelegate {
                    switch delegate.options.style {
                    case .preview: break
                    case .singleSelection:
                        pickerDelegate.photoBrowser(delegate, didSelect: selection)
                    case .multiSelection:
                        pickerDelegate.photoBrowser(delegate, didSelect: selection)
                    }
                }
            }
        }
        
    }
    
}

//
//  QNPhotoController.swift
//  App
//
//  Created by 红军张 on 2016/12/12.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
import Swiften

class QNPhotoController: UIViewController {
    
    var collectionfoot: CollectionReusableHeadre!
    var collectionHeader: UICollectionReusableView!
    
    @IBOutlet weak var photocollectionview: CollectionMjResh!
    
    var imageUrldt: [String]?
    override func viewWillAppear(animated: Bool) {
        //        viewWillAppear(animated)
        if let url = session.object(forKey: "funcationupdateimageUrlData"){
            imageUrldt = url as? [String]
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "上传列表"
        initcollectionMjrefresh()
        initCollectionview()
        initData()
    }
    
    func initcollectionMjrefresh(){
        photocollectionview.noDataNotice = "无数据可加载"
        photocollectionview.refreshDelegate = self
        photocollectionview.configRefreshable(headerEnabled: true, footerEnabled: true)
        //        collectionView.refreshData()
    }
    func initCollectionview(){
        self.view.backgroundColor = rgb(242,245,249)
        
        //注册一个cell
        photocollectionview.registerNib(UINib(nibName: "QNCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "cell")
        //注册一个headView
        photocollectionview.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        photocollectionview.registerNib(UINib(nibName: "CollectionReusableHeadre",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
        
        //        layout.headerReferenceSize = CGSizeZero //CGSizeMake(App_width,44)
        //        layout.footerReferenceSize = CGSizeZero //CGSizeMake(App_width,80)
    }
    func initData(){
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
//Mark: ------ UICollectionViewDataSource
extension QNPhotoController: UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imageUrldt = imageUrldt{
            return imageUrldt.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! QNCollectionViewCell
        if let imageUrldt = imageUrldt{
            cell.bindData(imageUrldt,functionTitle: [""],atIndex :indexPath)
        }
        return cell
    }
}

//Mark: ------ UICollectionViewDelegate
extension QNPhotoController: UICollectionViewDelegate{
    //返回自定义HeadView或者FootView，我这里以headview为例
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        if kind == UICollectionElementKindSectionHeader {
            collectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headView", forIndexPath: indexPath)
            collectionHeader.backgroundColor = UIColor.clearColor()
            return collectionHeader
        }else if kind == UICollectionElementKindSectionFooter{
            collectionfoot = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footerView", forIndexPath: indexPath) as? CollectionReusableHeadre
            if collectionfoot == nil{
                collectionfoot = NSBundle.mainBundle().loadNibNamed("CollectionReusableViewFooter", owner: nil, options: nil)!.first as? CollectionReusableHeadre
            }
            collectionfoot.backgroundColor = UIColor.clearColor()
        }
        return collectionfoot
    }
    //点击
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //        switch indexPath.item {
        //        case 0:
        //            self.performSegueWithIdentifier("gradient", sender: nil)
        //        case 1:
        //            self.performSegueWithIdentifier("filter", sender: nil)
        //        case 2:
        //            self.performSegueWithIdentifier("complexFilter", sender: nil)
        //        case 3:
        //            let baidu = BaiduMapViewController()
        //            baidu.hidesBottomBarWhenPushed = true
        //            self.navigationController?.pushViewController(baidu, animated: true)
        //        case 10:
        //            let upload = uploadPicturesView()
        //            upload.hidesBottomBarWhenPushed = true
        //            self.navigationController?.pushViewController(upload, animated: true)
        //        default:
        //            break
        //        }
    }
}
//Mark: ------ UICollectionViewDelegateFlowLayout
extension QNPhotoController: UICollectionViewDelegateFlowLayout{
    //返回cell 上下左右的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(8, 12, 8, 12)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let cellwidth = (App_width - 24 - 24)/4
        let cellHight = (App_width - 24 - 24)/4 * 33/28 - 2
        return CGSize(width: cellwidth,height: cellHight)
    }
}
//Mark: ------ 刷新代理
extension QNPhotoController: MJCollectionViewRefreshDelegate{
    func Collection(Collection: CollectionMjResh, refreshDataWithType refreshType: CollectionMjResh.RefreshType) {
        Collection.endRefreshing(num: 11, count: 3, NoDataNoticeViewKinds: 0)
    }
}

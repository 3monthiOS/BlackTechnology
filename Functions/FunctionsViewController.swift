//
//  FunctionsViewController.swift
//  App
//
//  Created by 红军张 on 16/9/13.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

class FunctionsViewController: APPviewcontroller {
    
    weak var collectionView: CollectionMjResh!
    var collectionfoot: CollectionReusableViewFooter!
    var collectionHeader: UICollectionReusableView!
    
    var functionTitleData = ["渐变","简单滤镜","复杂滤镜1","地图","听歌","录音","看视频","拍照","地图","六","⑦"]
    var imageData = ["功能头像0","功能头像1","功能头像2","功能头像3","功能头像4","功能头像5","功能头像6","功能头像7","功能头像8","功能头像9","功能头像10","功能头像11","功能头像12"]
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "功能列表"
      self.navigationController?.navigationBar.translucent = false
        initcollectionMjrefresh()
        initCollectionview()
        initData()
    }
    func initcollectionMjrefresh(){
        collectionView.noDataNotice = "无数据可加载"
        collectionView.refreshDelegate = self
        collectionView.configRefreshable(headerEnabled: true, footerEnabled: true)
        collectionView.refreshData()
    }
    func initCollectionview(){
        self.view.backgroundColor = rgb(242,245,249)
      
        //注册一个cell
        collectionView.registerNib(UINib(nibName: "QdanCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.registerNib(UINib(nibName: "QdanCollectionViewzeroCell",bundle: nil), forCellWithReuseIdentifier: "cell0")
        
        //注册一个headView
        collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        collectionView.registerNib(UINib(nibName: "CollectionReusableViewHeadre",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")

//        layout.headerReferenceSize = CGSizeZero //CGSizeMake(App_width,44)
//        layout.footerReferenceSize = CGSizeZero //CGSizeMake(App_width,80)
    }
    func initData(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
}
    //Mark: ------ UICollectionViewDataSource
extension FunctionsViewController: UICollectionViewDataSource{
  
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return functionTitleData.count
    }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! QdanCollectionViewCell
    cell.bindData(imageData,functionTitle: functionTitleData,atIndex :indexPath)
    return cell
  }
}

 //Mark: ------ UICollectionViewDelegate
extension FunctionsViewController: UICollectionViewDelegate{
  //返回自定义HeadView或者FootView，我这里以headview为例
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
    if kind == UICollectionElementKindSectionHeader {
      collectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headView", forIndexPath: indexPath)
      collectionHeader.backgroundColor = UIColor.clearColor()
      return collectionHeader
    }else if kind == UICollectionElementKindSectionFooter{
      collectionfoot = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footerView", forIndexPath: indexPath) as? CollectionReusableViewFooter
      if collectionfoot == nil{
        collectionfoot = NSBundle.mainBundle().loadNibNamed("CollectionReusableViewFooter", owner: nil, options: nil)!.first as? CollectionReusableViewFooter
      }
      collectionfoot.backgroundColor = UIColor.clearColor()
    }
    return collectionfoot
  }
  //点击
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    switch indexPath.item {
    case 0:
      self.performSegueWithIdentifier("gradient", sender: nil)
    case 1:
      self.performSegueWithIdentifier("filter", sender: nil)
    case 2:
      self.performSegueWithIdentifier("complexFilter", sender: nil)
    case 3:
        let baidu = BaiduMapViewController()
        baidu.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(baidu, animated: true)
    default:
      break
        }
    }
}
 //Mark: ------ UICollectionViewDelegateFlowLayout
extension FunctionsViewController: UICollectionViewDelegateFlowLayout{
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
extension FunctionsViewController: MJCollectionViewRefreshDelegate{
  func Collection(Collection: CollectionMjResh, refreshDataWithType refreshType: CollectionMjResh.RefreshType) {
    Collection.endRefreshing(num: 11, count: 3, NoDataNoticeViewKinds: 0)
  }
}

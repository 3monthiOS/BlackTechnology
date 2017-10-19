//
//  FirstViewController.swift
//  App
//
//  Created by 红军张 on 2016/12/16.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

class articlesOBj {
    var title = ""
    var url = ""
    var readnumber = ""
}
class FirstViewController: UIViewController {

    @IBOutlet weak var zhjtable: ZHJtableview!
    
    let articlesData = [
        ["算法合集":"https://mp.weixin.qq.com/s?__biz=MzUyNDM5ODI3OQ==&mid=100000064&idx=1&sn=c3a4dfa776ce71624d205296297300ed&chksm=7a2cbae84d5b33feedb2bb3505a12a18cf43e94ec33517bfd62ec307dc37435e03459212219f&mpshare=1&scene=23&srcid=1018vePsKRlwWEnwNudhRGBh#rd"],
        ["iOS开发系列--音频播放、录音、视频播放、拍照、视频录制 - KenshinCui - 博客园":"http://www.cnblogs.com/kenshincui/p/4186022.html"],
        ["Swift 教程 - Swift 语言学习 - Swift code - SwiftGG 翻译组 - 高质量的 Swift 译文网站":"http://swift.gg/"],
        ["WKWebView 那些坑":"https://mp.weixin.qq.com/s/rhYKLIbXOsUJC_n6dt9UfA"],
        ["重识 Objective-C Runtime - 看透 Type 与 Value · sunnyxx的技术博客":"http://blog.sunnyxx.com/2016/08/13/reunderstanding-runtime-1/"],
        ["青玉伏案 - 博客园":"http://www.cnblogs.com/ludashi/"],
        ["[iOS] 阿里开源组件化方案 BeeHive - 推酷":"http://www.tuicool.com/articles/3umaEvM"],
        ["滴滴 iOS 动态化方案 DynamicCocoa 的诞生与起航 - CSDN - 微读吧":"http://www.weidu8.net/wx/1008148211323615"]]
    var dataArray = [[articlesOBj]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initdata()
        initZHJtableview()
    }
    func initdata(){
        for atr:[String:String] in articlesData {
            let obj = articlesOBj()
            obj.title = atr.keys.first!
            obj.url = atr.values.first!
            obj.readnumber = "浏览" + "\(arc4random()%100)"
            dataArray.append([obj])
        }
    }
    
    func initZHJtableview(){
        zhjtable.tableveiwData = dataArray
        zhjtable.needRefreshControl = [true,true]
        zhjtable.delgate = self
        zhjtable.dataSources = self
        zhjtable.register(UINib(nibName: "articlesCell", bundle: nil), forCellReuseIdentifier: "articlesCell")
    }
    fileprivate func configureTable(){
        zhjtable.estimatedRowHeight = 44
        zhjtable.rowHeight = UITableViewAutomaticDimension
    }
    fileprivate func randomNum()-> CGFloat{
        return CGFloat(arc4random() % 255) / 255.0
    }
    
    fileprivate func randomColor()-> UIColor{
        return UIColor(red: randomNum() , green: randomNum(), blue: randomNum(), alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
//MARK:------- MJ
extension FirstViewController : ZHJtableviewDelgate {
    func bindtableViewRefresh(_ tableView: TableViewMjResh, refreshDataWithType refreshType: TableViewMjResh.RefreshType) {
        // 这里是下拉刷新的回调 用于请求数据
//        dataArray[0].append(String(arc4random()%100))
        tableView.endRefreshing(num: dataArray.count, count: 1)
    }
    func bindCellData(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell? {
        let identifier = "articlesCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? articlesCell
        let articl = dataArray[indexPath.section][indexPath.row]
        cell?.contentText.text = articl.title
        cell?.readNumber.text = articl.readnumber
        return cell
    }
    func didSelectRowAtIndexPath(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let articl = dataArray[indexPath.section][indexPath.row]
        let web = ZHJWebViewController()
        web._urlString = articl.url
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(web, animated: true)
    }
}
//MARK:------- UITableViewDataSource
extension FirstViewController: ZHJtableviewDataSource {
    func bindHeaderView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  UIView()
        view.frame = CGRect(x: 0, y: 0, width: App_width + 25, height: 20)
        return view
    }
}

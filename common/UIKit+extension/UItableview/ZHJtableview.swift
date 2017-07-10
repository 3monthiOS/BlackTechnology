//
//  ZHJtableview.swift
//  App
//
//  Created by 红军张 on 2016/12/15.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

protocol ZHJtableviewDelgate {
    func bindCellData(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell?
    func didSelectRowAtIndexPath(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    func bindtableViewRefresh(_ tableView: TableViewMjResh, refreshDataWithType refreshType: TableViewMjResh.RefreshType)
}
@objc protocol ZHJtableviewDataSource {
    @objc optional func bindHeaderView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    @objc optional func bindFooterView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
}
class ZHJtableview: TableViewMjResh {

    var dataSources: ZHJtableviewDataSource?
    var delgate: ZHJtableviewDelgate? {
        willSet{
            if delgate == nil && newValue != nil{
                if needRefreshControl[0] || needRefreshControl[1] {
                    initMjrefresh(needRefreshControl)
                }
            }
        }
    }
    var tableveiwData: [[Any]]?{
        didSet{
            UnpackData()
        }
    }
    
    var canEditRow:Bool = false
    var needRefreshControl:[Bool] = [false,false]
    var heraerViewheight = 1.0
    var footerViewheight = 1.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource = self
        self.delegate = self
        self.refreshTableDelegate = self
    }
    func initMjrefresh(_ isok: [Bool]){
        self.noDataNotice = "无数据可加载"
        self.configRefreshable(headerEnabled: isok[0], footerEnabled: isok[1])
    }
    func UnpackData(){
        guard let _ = tableveiwData else {
            self.tableveiwData = [[""]]
            alert("tableveiwData没有初始化,不能构建页面")
            return
        }
    }
}
//MARK:------- MJ
extension ZHJtableview : MJTableViewRefreshDelegate{
    func tableView(_ tableView: TableViewMjResh, refreshDataWithType refreshType: TableViewMjResh.RefreshType) {
        delgate?.bindtableViewRefresh(tableView, refreshDataWithType: refreshType)
    }
}

//MARK:------- UITableViewDataSource
extension ZHJtableview: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (tableveiwData?.count)!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableveiwData![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (delgate?.bindCellData(tableView, cellForRowAtIndexPath: indexPath))!
    }
}
//MARK:------- UITableViewDelegate
extension ZHJtableview: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//选中哪一行
        tableView.deselectRow(at: indexPath, animated: false)
        delgate?.didSelectRowAtIndexPath(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let heagerview = dataSources?.bindHeaderView?(tableView, viewForHeaderInSection: section){
            return heagerview
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footerview = dataSources?.bindFooterView?(tableView, viewForFooterInSection: section){
            return footerview
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = dataSources?.bindHeaderView?(tableView, viewForHeaderInSection: section){
            return CGFloat(heraerViewheight)
        }
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let _ = dataSources?.bindFooterView?(tableView, viewForFooterInSection: section){
            return CGFloat(footerViewheight)
        }
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditRow
    }
    //    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    //        cell.addGradientBackgroundColorWith(randomColor(), middleColor: randomColor())
    //    }
}

//
//  RCsetingController.swift
//  App
//
//  Created by 红军张 on 2017/11/8.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class RCsetingController: CustomViewController {

    @IBOutlet weak var setingTable: ZHJtableview!
    var dataArray = [["创建讨论组","清除缓存"]]
    var userArray = [User]()
    
    override func setup() {
        super.setup()

        initZHJtableview()
    }

    func initZHJtableview() {
        setingTable.tableveiwData = dataArray as [[AnyObject]]
        setingTable.needRefreshControl = [true,true]
        setingTable.delgate = self
        setingTable.dataSources = self
        setingTable.heraerViewheight = 1
        setingTable.footerViewheight = 1
    }
}
//MARK:------- MJ
extension RCsetingController: ZHJtableviewDelgate {
    func bindtableViewRefresh(_ tableView: TableViewMjResh, refreshDataWithType refreshType: TableViewMjResh.RefreshType) {
        // 这里是下拉刷新的回调 用于请求数据
        tableView.endRefreshing(num: dataArray.count, count: 1)
    }
    
    func bindCellData(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell? {
        let identifier = "cellRC"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.value2,reuseIdentifier: identifier)
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.textColor = UIColor.gray
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell?.textLabel?.text = dataArray[indexPath.section][indexPath.row]
        return cell
    }
    
    func didSelectRowAtIndexPath(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let membervc = ShowGroupsMembersController()
            membervc.userData = userArray
            self.navigationController?.present(membervc, animated: false, completion: nil)
        case 1:
            RCIM.shared().clearUserInfoCache()
            RCIM.shared().clearGroupUserInfoCache()
            RCIM.shared().clearGroupInfoCache()
        default:
            Log.info("呦，写bug呢")
        }
    }
}

extension RCsetingController: ZHJtableviewDataSource{
    func bindHeaderView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return nil
    }
}

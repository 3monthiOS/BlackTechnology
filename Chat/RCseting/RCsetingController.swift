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
        createDiscussionGroupsChat()
    }

    func initZHJtableview() {
        setingTable.tableveiwData = dataArray as [[AnyObject]]
        setingTable.needRefreshControl = [true,true]
        setingTable.delgate = self
        setingTable.dataSources = self
        setingTable.heraerViewheight = 1
        setingTable.footerViewheight = 1
    }
    
    // MARK: -- 用户集合
    func createDiscussionGroupsChat(){
        userArray.removeAll()
        for u in RCtokenArray {
            let userobj = User()
            userobj.userphone = u.key
            userobj.rcToken = u.value
            if u.key == "15249685697" {
                userobj.rcUserId = "cb"
                userobj.rcName = "常博"
            } else if u.key == "012345678910" {
                userobj.rcUserId = "CB0"
                userobj.rcName = "常六"
            } else if u.key == "13968034167" {
                userobj.rcUserId = "ZW"
                userobj.rcName = "宗伟"
            } else if u.key == "15225147792" {
                userobj.rcUserId = "GF"
                userobj.rcName = "小芳"
            } else if u.key == "18336093422" {
                userobj.rcUserId = "zhj1214"
                userobj.rcName = "小军"
            } else if u.key == "00000000000" {
                userobj.rcUserId = "ZW0"
                userobj.rcName = "单身狗"
            }
            userArray.append(userobj)
        }
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

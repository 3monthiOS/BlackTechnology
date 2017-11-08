//
//  RCcontactPersonController.swift
//  App
//
//  Created by 红军张 on 2017/11/8.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class RCcontactPersonController: CustomViewController {

    @IBOutlet weak var contactPersonTable: ZHJtableview!
    var dataArray = [[],["讨论组0","讨论组1"],["王麻子","二狗子"]]
    var userArray = [User]()
    
    override func setup() {
        super.setup()
        
        initZHJtableview()
        createDiscussionGroupsChat()
    }
    
    func initZHJtableview() {
        contactPersonTable.tableveiwData = dataArray as [[AnyObject]]
        contactPersonTable.needRefreshControl = [true,true]
        contactPersonTable.delgate = self
        contactPersonTable.dataSources = self
        contactPersonTable.heraerViewheight = 25
        contactPersonTable.footerViewheight = 1
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
extension RCcontactPersonController: ZHJtableviewDelgate {
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
        if indexPath.section == 0 {
            // 与谁 私聊
            let chatWithSelf = RCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: userArray[indexPath.row].rcUserId)
            chatWithSelf?.title = userArray[indexPath.row].rcName
            let bar = self.tabBarController as! RAMAnimatedTabBarController
            bar.hideAndShowCustomIcons(isHidden: true)
            self.navigationController?.pushViewController(chatWithSelf!, animated: true)
        } 
    }
}

extension RCcontactPersonController: ZHJtableviewDataSource {
    func bindHeaderView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Width(), height: 25))
        //            view.backgroundColor = rgb(220, 220, 220)
        view.backgroundColor = UIColor.clear
        
        let btn = UIButton(type: .custom)
        view.addSubview(btn)
        btn.frame = CGRect(x: 12, y: 0, width: view.width, height: view.height)
        btn.tag = section
        btn.addTarget(self, action: #selector(showFriends(btn:)), for: .touchUpInside)
        btn.titleLabel?.textAlignment = .left
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        if section == 0 {
            btn.setTitle("我的好友", for: .normal)
        } else if section == 1 {
            btn.setTitle("讨论组", for: .normal)
        } else {
            btn.setTitle("陌生人", for: .normal)
        }
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.setTitleColor(UIColor.black, for: .normal)
        return view
    }
    
    func showFriends(btn: UIButton){
        if btn.tag == 0 {
            if dataArray[0].count > 1 {
                dataArray = [[],["讨论组0","讨论组1"],["王麻子","二狗子"]]
            } else {
                var nameArray = [String]()
                for obj in userArray {
                    nameArray.append(obj.rcName!)
                }
                dataArray = [nameArray,["讨论组0","讨论组1"],["王麻子","二狗子"]]
            }
            contactPersonTable.tableveiwData = dataArray as [[AnyObject]]
        }
        contactPersonTable.reloadData()
        //        self.setingTableview.reloadSections(IndexSet(integersIn: NSMakeRange(0, 1).toRange()!), with: .fade)
    }
}

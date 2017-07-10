//
//  RCsetingsController.swift
//  App
//
//  Created by 红军张 on 2017/7/3.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class RCsetingsController: UIViewController {
    
    @IBOutlet weak var setingTableview: ZHJtableview!

    var dataArray = [[],["创建讨论组","清除融云缓存"]]
    var userarray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "融云"
        initZHJtableview()
    }
    
    func initZHJtableview(){
        setingTableview.tableveiwData = dataArray
        setingTableview.needRefreshControl = [true,true]
        setingTableview.delgate = self
        setingTableview.dataSources = self
        setingTableview.heraerViewheight = 55
        setingTableview.footerViewheight = 1
    }
    // MARK: -- 创建讨论组
    func createDiscussionGroupsChat(){
        userarray.removeAll()
        for u in RCtokenArray {
            let userobj = User()
            userobj.userphone = u.key
            userobj.rcToken = u.value
            userarray.append(userobj)
        }
        let membervc = ShowGroupsMembersController()
        membervc.userData = userarray
        self.navigationController?.present(membervc, animated: false, completion: nil)
    }
    
    func showFriends(){
        if dataArray[0].count>1 {
            dataArray = [[],["创建讨论组","清除融云缓存"]]
        }else{
            dataArray = [["张三","李四","王麻子","小二","王五","的撒多","单身的"],["创建讨论组","清除融云缓存"]]
        }
        setingTableview.tableveiwData = dataArray
        setingTableview.reloadData()
//        self.setingTableview.reloadSections(IndexSet(integersIn: NSMakeRange(0, 1).toRange()!), with: .fade)
    }
}

//MARK:------- MJ
extension RCsetingsController: ZHJtableviewDelgate {
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
        if indexPath.section != 0 {
            switch indexPath.row {
            case 0:
                createDiscussionGroupsChat()
            case 1:
                RCIM.shared().clearUserInfoCache()
                RCIM.shared().clearGroupUserInfoCache()
                RCIM.shared().clearGroupInfoCache()
            default:
                Log.info("呦，写bug呢")
            }
        }
    }
}
extension RCsetingsController: ZHJtableviewDataSource{
    func bindHeaderView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: Width(), height: 55))
            view.backgroundColor = rgb(220, 220, 220)
            let btn = UIButton(type: .custom)
            view.addSubview(btn)
            btn.frame = CGRect(x: 12, y: 0, width: Width(), height: 55)
            btn.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
            btn.titleLabel?.textAlignment = .left
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            btn.setTitle("好友列表", for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            
            return view
        }else{
            return nil
        }
    }
}

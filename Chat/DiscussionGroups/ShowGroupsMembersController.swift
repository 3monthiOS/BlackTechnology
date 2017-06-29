//
//  ShowGroupsMembersController.swift
//  App
//
//  Created by 红军张 on 2017/6/29.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class ShowGroupsMembersController: UIViewController {

    @IBOutlet weak var groupsmembersTable: UITableView!
    var userData: [User]?
    var userIDArray = ["zhj1214","CB","CB0","ZW","ZW0","GF"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func quchong(array:[String])-> Array<String>{
//        let quchong =  ["zhj","CB","CB0","ZW","ZW0","HH","CB","ZW","zhj"]
        let results = array.reduce([String]()) { (result, it) -> [String] in
            return  !result.contains(it) ? result + [it]  : result
        }
        return results
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            if self.userIDArray.count == 6{return}
            let result = Array(Set(self.userIDArray[6...self.userIDArray.count-1]))
            prompt("请输入讨论组名称", title: "创建讨论组", text: "", placeholder: "请输入", completion: { (str) in
                RCIM.shared().createDiscussion(str!, userIdList: result, success: { (RCDiscussio) in
                    Log.info("创建讨论组成功")
                }) { (error) in
                    Log.info("创建讨论组失败\(error)")
                }
            })
            
        }
    }
}

extension ShowGroupsMembersController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (userData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifler = "menbercells"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifler) as? mebersCell
        if (cell == nil) {
            cell = Bundle.main.loadNibNamed("mebersCell", owner: nil, options: nil)?.last as? mebersCell
            cell?.accessoryType = .none
        }
        cell?.loadContent(data: userData![indexPath.row], selectet: false)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as? mebersCell
        userIDArray.append(userIDArray[indexPath.row])
        cell?.selectedEvent()
    }
}

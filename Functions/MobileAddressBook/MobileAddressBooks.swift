//
//  MobileAddressBooks.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/7/5.
//  Copyright © 2016年 侯伟. All rights reserved.
//
import Foundation
import Swiften
import UIKit
import AddressBookUI
import AddressBook
import Contacts
import ContactsUI

class MobileAddressBooks: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{

	var mobileType = "No" // 平台推荐客源

	var isRecommend: Bool? = false// 是否报备
	var selectContact: ((success: Bool, name: String?, mobile: String?) -> Void)?

	var iphoneUserArray: Array<Dictionary<String, AnyObject>> = []

	var userNmaeArray: Array<Array<String>> = [] // 联系人数组
	var nameZIMUArray: [String]? // 字母数组
	var userNmaearrays = [String]() // 姓名数组用来检索

	var mobileControl = MObileFunction()

	var result = [String]() // 搜索结果数组

	var searchStatus = "UNsearch"

	var keyWords = ["obj": "", "offset": 0, "size": 25]

	var mobileObjectArray = [MobileAddress]()

	var mobileObjects = [MobileAddresObject]()

	var searchBar: UISearchBar?

	@IBOutlet weak var tableView: LDTableView!

	override func viewWillAppear(animated: Bool) {
//		super.viewWillAppear(animated)
		//self.tabBarController?.tabBar.hidden = true
		if mobileType == "MObile" {
			self.getMObileData()
			self.title = "电话本客户"
		} else {
			self.title = "平台推送客源"
		}
		if (self.searchBar == nil) {
			initSearchBar()
		}
	}
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		//self.tabBarController?.tabBar.hidden = false
		self.mobileObjectArray = [MobileAddress]()
		self.userNmaearrays = [String]()
		self.keyWords = ["obj": "", "offset": 0, "size": 25]
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.initMjrefresh()
	}
	func initSearchBar() {
		self.searchBar = UISearchBar(frame: CGRectMake(0, 0, App_width, 44))
		searchBar!.placeholder = "搜索"
		searchBar!.barStyle = UIBarStyle.Default
		searchBar!.searchBarStyle = UISearchBarStyle.Default
		searchBar!.translucent = true
		searchBar!.showsSearchResultsButton = false
		searchBar!.showsScopeBar = false
		searchBar!.delegate = self
		self.tableView.tableHeaderView = searchBar!
	}
	// MARK: -------- 报备
	func cancel() {
		isRecommend = false
		self.closeViewControllerAnimated(true)
	}
	// MARK: - -------- 房源 数据获取
	func getMobileRecommendData() {
		if keyWords["obj"]!.isEqual("") {
            self.tableView.mj_header.endRefreshing()
			return
		}
//		api.mobileRecommend.get(keyWords) { (data: MobileRecommend) in
//			self.mobileObjects = data.list!
//             self.tableView.mj_header.endRefreshing()
//		}
        self.tableView.mj_header.endRefreshing()
	}
	// MARK: - -------- 通讯录 数据
	func getMObileData() {
		var user: MobileAddress?
		nameZIMUArray = [String]()
		iphoneUserArray = mobileControl.getSysContacts()
		for dic in iphoneUserArray {
			user = MobileAddress()
			// 获取 电话数组   如果没有电话 就不展示此联系人
			if let number = dic["Phone"] as? [String] where number.count > 0 {
				for phone in number {
					let mobilephone = RetrieveMobileAddressbook().RemoveSpecialCharacter(phone)
					if mobileControl.checkMobileReg(mobilephone) {
						user?.mobile = mobilephone
						break
					}
				}
				// 如果有手机号  就保存 否则就不保存
				if user?.mobile != "" {
					// 获取姓名数组
					if let name = dic["fullName"] as? String where !name.isEmpty {
						user?.name = name
					} else {
						if let name = dic["Nikename"] as? String where !name.isEmpty {
							user?.name = name
						} else {
							user?.name = "姓名未知"
						}
					}
					if dic["TX"] != nil {
						user?.avatars = dic["TX"] as? UIImage
					}
					userNmaearrays.append(user!.name)
					mobileObjectArray.append(user!)
				}
			}
		}
//		userNmaeArray = ChineseString.LetterSortArray(userNmaearrays) as! Array<Array<String>>
//		nameZIMUArray = ChineseString.IndexArray(userNmaearrays) as? [String]
        
//        var userNmaeArray: Array<Array<String>> = [] // 联系人数组
        
        userNmaeArray = RetrieveMobileAddressbook().LetterSortArray(userNmaearrays) as! Array<Array<String>>
        nameZIMUArray = RetrieveMobileAddressbook().IndexArray(userNmaearrays)
        
        
        nameZIMUArray?.insert("\(UITableViewIndexSearch)", atIndex: 0)
		self.tableView.mj_header.endRefreshing()
	}


	// MARK: - -------- UITableViewDelegate
	func numberOfSectionsInTableView(tableView: UITableView) -> Int { // 区
		if self.mobileType != "MObile" {
			return 1
		}
		if self.searchStatus == "UNsearch" {
			if let number = nameZIMUArray?.count {
				return number - 1
			}
		}
		return 1
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // 行数
		if self.mobileType != "MObile" {
			tableView.separatorStyle = UITableViewCellSeparatorStyle.None
			return mobileObjects.count
		}
		if self.searchStatus != "UNsearch" {
			return result.count
		}
		return userNmaeArray[section].count
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if self.mobileType != "MObile" {
			return 44
		}
		return 45
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		let identifier = "cell13"
		var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
		if cell == nil {
			cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
		}
		cell?.textLabel?.textColor = UIColor.blackColor()
		cell?.detailTextLabel?.textColor = UIColor.lightGrayColor()
		cell?.detailTextLabel?.font = UIFont(name: "Menlo-Regular", size: 14)

		if self.mobileType != "MObile" {
			let object = mobileObjects[indexPath.row]
			cell?.textLabel?.text = object.name
			cell?.detailTextLabel?.text = object.mobile
			return cell!
		}
		// 通讯录
//		let cell = NSBundle.mainBundle().loadNibNamed("UserIphoneNumbercell", owner: nil, options: nil)[0] as? UserIphoneNumbercell
		guard userNmaeArray.count > 0 else { return cell! }
		var name = ""
		var MOB = MobileAddress()
		if self.searchStatus != "UNsearch" {
			guard result.count > 0 else { return cell! }
			name = self.result[indexPath.row]
		} else {
			name = (userNmaeArray[indexPath.section])[indexPath.row]
		}
		for mob in mobileObjectArray {
			if mob.name == name {
				MOB = mob
				break
			}
		}
		cell?.textLabel?.text = MOB.name
		cell?.detailTextLabel?.text = MOB.mobile
		return cell!
	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) { // 选中哪一行
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		if self.mobileType != "MObile" {
			// 打电话 发短信 功能
			mobileControl.userNumber = cell?.detailTextLabel?.text
			mobileControl.userName = cell?.textLabel?.text
			mobileControl.isShow = true
			mobileControl.presentOverViewController(self)
		} else {
//			let cell = tableView.cellForRowAtIndexPath(indexPath) as! UserIphoneNumbercell
			if isRecommend == true {
				if let contact = selectContact {
					contact(success: true, name: cell?.textLabel?.text, mobile: cell?.detailTextLabel?.text)
				}
				cancel()
			} else {
				mobileControl.userNumber = cell?.detailTextLabel?.text
				mobileControl.userName = cell?.textLabel?.text
				mobileControl.isShow = false
				mobileControl.presentOverViewController(self)
			}
		}
	}
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if self.mobileType != "MObile" {
			return CGFloat .min
		}
		return 25
	}
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if self.mobileType != "MObile" {
			return ""
		}
		return nameZIMUArray![section + 1]
	}
	// MARK: - 添加索引列
	func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		tableView.sectionIndexBackgroundColor = UIColor.clearColor()
		if self.mobileType != "MObile" {
			return [""]
		} else {
			if self.searchStatus == "UNsearch" {
				if nameZIMUArray![0] != "\(UITableViewIndexSearch)" {
					nameZIMUArray?.insert("\(UITableViewIndexSearch)", atIndex: 0)
				}
				return nameZIMUArray
			}
			return [""]
		}
	}
	// MARK: - 索引列点击事件
	func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
		if index == 0 {
			tableView.setContentOffset(CGPoint(x: 0, y: -62), animated: true)
			return -1
		}
		tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index - 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
		return index
	}
	// MARK: - -------- 搜索框
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		searchBar.showsCancelButton = true
        if mobileType == "MObile" && userNmaearrays.count<1 {
            alert("无用户可搜索")
            return
        }
		// 没有搜索内容时显示全部内容
		if searchText == "" {
			self.result = self.userNmaearrays
		} else {
			// 匹配用户输入的前缀，不区分大小写
			self.result = []
			for arr in self.userNmaearrays {
				if arr.lowercaseString.hasPrefix(searchText.lowercaseString) {
					self.result.append(arr)
                }else{
                    if arr.lowercaseString.hasSuffix(searchText.lowercaseString){
                        self.result.append(arr)
                    }
                }
			}
			self.searchStatus = "search"
		}
	}
	// MARK: - 搜索触发事件，点击虚拟键盘上的search按钮时触发此方法
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var error: Unmanaged<CFErrorRef>?
        if !(ABAddressBookCreateWithOptions(nil, &error) != nil) {
            alert("请到设置中打开通讯录授权")
            return
        }
		if self.mobileType != "MObile" {
			keyWords = ["obj": "\(searchBar.text)", "offset": 0, "size": 25]
			self.getMobileRecommendData()
		}
        tableView.reloadData()
		searchBar.showsCancelButton = false
		searchBar.resignFirstResponder()
	}

	// 书签按钮触发事件
	func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
		print("搜索历史")
	}
	// 取消按钮触发事件
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		searchBar.showsCancelButton = false
		searchBar.resignFirstResponder()
		// 搜索内容置空
		searchBar.text = ""
		self.searchStatus = "UNsearch"
		self.tableView.reloadData()
	}
	
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
extension MobileAddressBooks: MJTableViewRefreshDelegate {
    // MARK: - -------- MJ 代理
    func initMjrefresh() {
        tableView.noDataNotice = "暂时没有客户房源"
        tableView.refreshData()
        tableView.refreshTableDelegate = self
        tableView.configRefreshable(headerEnabled: true, footerEnabled: true)
    }
    // MARK: - -------- 刷新代理
    func tableView(tableView: LDTableView, refreshDataWithType refreshType: LDTableView.RefreshType){
        if self.mobileType != "MObile" { // 客户房源
            if refreshType == .Header {
                self.mobileObjects = [MobileAddresObject]()
            } else {
                var j = keyWords["offset"] as! Int
                j = j + 1
                keyWords = ["obj": "\(searchBar!.text)", "offset": j, "size": 25]
            }
            getMobileRecommendData()
            
        } else {
            if self.searchStatus == "UNsearch" { // 通讯录
                self.mobileObjectArray = [MobileAddress]()
                self.userNmaearrays = [String]()
                getMObileData()
            }
        }

    }
    
}

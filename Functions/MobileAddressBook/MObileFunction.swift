//
//  MObileFunction.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/7/8.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import UIKit
//import Swiften
import Foundation
import MessageUI
import AddressBookUI
import AddressBook
import Contacts
import ContactsUI

class ContactsStore {
	@available(iOS 9.0, *)
	static let sharedStore = CNContactStore()
}
class MObileFunction: ActionSheetController, MFMessageComposeViewControllerDelegate, ABNewPersonViewControllerDelegate, ABPersonViewControllerDelegate {

	fileprivate static var sharedInstance: MObileFunction? = nil
	var userNumber: String?
	var userName: String?
	var isShow = false
    var messageBoy = ""
	@IBOutlet weak var SaveBtn: UIButton!
	@IBOutlet weak var textingBtn: UIButton!
	@IBOutlet weak var IphoneCallBtn: UIButton!
	@IBOutlet weak var recommendedBtn: UIButton!
	@IBOutlet weak var canleBtn: UIButton! {
		didSet {
			canleBtn.layer.masksToBounds = true
			canleBtn.layer.cornerRadius = 6
		}
	}
	@IBOutlet weak var popupHight: NSLayoutConstraint!

	static func shared() -> MObileFunction {
		if sharedInstance == nil {
			sharedInstance = MObileFunction()
		}
		return sharedInstance!
	}
	override func viewWillAppear(_ animated: Bool) {
		if isShow {
			SaveBtn.isHidden = false
		} else {
			SaveBtn.isHidden = true
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()

	}
	// Mark:- -------保存次联系人 到电话簿
	@IBAction func saveMobilephone(_ sender: AnyObject) {
		if isempty() { alert("联系人信息不完整"); return }
		self.SaveMobileBook(userName!, userNumber: userNumber!)
	}
	// Mark:- -------打电话
	@IBAction func IphoneCall(_ sender: AnyObject) {
		if isempty() { alert("联系人信息不完整"); return }
		self.phoneCall(userNumber!)
//		self.dismissActionSheetController()
	}
	func phoneCall(_ phoneStr: String) {
		let phoneNum = "tel:\(phoneStr)"
		let callWedView = UIWebView()
		let request = URLRequest(url: URL(string: phoneNum)!)
		callWedView.loadRequest(request)
		self.view.addSubview(callWedView)
	}
	// Mark:- -------推荐
	@IBAction func recommended(_ sender: AnyObject) {
	}
	// Mark:- -------发短信
	@IBAction func texting(_ sender: AnyObject) {
		self.sendMessage(self,MessageContent: "")
	}
    func sendMessage(_ controller: UIViewController, MessageContent: String) {
        self.messageBoy = MessageContent
		if (self.canSendText()) {
			controller.present(self.configuredMessageComposeViewController(), animated: true, completion: nil)
		} else {
			alert("当前设备不支持短信功能")
		}
	}
	func canSendText() -> Bool {
		return MFMessageComposeViewController.canSendText()
	}
	func configuredMessageComposeViewController() -> MFMessageComposeViewController {
		let messageComposeVC = MFMessageComposeViewController()
		messageComposeVC.messageComposeDelegate = self // 设置代理，遵循代理方法
		// 属性设置
		if let number = userNumber {
			if checkMobileReg(number) {
				var numbers = [String]()
				numbers.append(self.userNumber!)
				messageComposeVC.recipients = numbers// 联系人列表
			}
		}
		// let inviteCode = NSUserDefaults.standardUserDefaults().stringForKey(kInviteCode)
		messageComposeVC.body = messageBoy
		return messageComposeVC
	}
	// Mark: --------发送短信代理
	func messageComposeViewController(_ controller: MFMessageComposeViewController,
		didFinishWith result: MessageComposeResult) {

			switch result {
			case .sent:
				print("短信已发送")
			case .cancelled:
				print("短信取消发送")
			case .failed:
				print("短信发送失败")
			}
			controller.dismiss(animated: true, completion: nil)
			MObileFunction.sharedInstance = nil
	}

	// Mark: -------- 创建新的联系人
	func EditNewContacts() {
		let personViewVC = ABPersonViewController()
		personViewVC.personViewDelegate = self
		personViewVC.allowsEditing = true
		personViewVC.isEditing = true
		personViewVC.allowsActions = true

		// let ab : mobileControl
		// personViewVC.displayedPerson = absk

		// let numb : Int32 = 1833609342
		// let numbs : Int32 =  27
		// personViewVC.setHighlightedItemForProperty(numb, withIdentifier: numbs)
		// ABRecordRef person = ABPersonCreate()
		// let abRef = ABAddressBookRef(initData())
		// abRef = ABAddressBookDataControllermakeABAddressBookR
		// personViewVC.displayedPerson = ABAddressBookGetPersonWithRecordID(abRef,nil)
		self.navigationController?.pushViewController(personViewVC, animated: true)
	}
	// Mark: -------- ABNewPersonViewControllerDelegate
	func personViewController(_ personViewController: ABPersonViewController, shouldPerformDefaultActionForPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
		return false
	}
	func newPersonViewController(_ newPersonView: ABNewPersonViewController, didCompleteWithNewPerson person: ABRecord?) {
		//
	}

	// Mark: -------- 平台 保存到通讯录
	func SaveMobileBook(_ userName: String, userNumber: String) {

		if userName.isEmpty || userNumber.isEmpty {
			alert("联系人信息不完整")
			return
		}
		if #available(iOS 9.0, *) {
			let mutableContact = CNMutableContact()

			mutableContact.nickname = userName
			mutableContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile,
				value: CNPhoneNumber(stringValue: userNumber))]

			let saveRequest = CNSaveRequest()
			saveRequest.add(mutableContact, toContainerWithIdentifier: nil)
			do {
				try ContactsStore.sharedStore.execute(saveRequest)
			} catch let error {
				print(error)
                self.dismissActionSheetController({
                    alert("保存失败")
                })
			}
            self.dismissActionSheetController({
                alert("保存成功")
            })
            
		} else {
			SaveMobileObject(userName, userNumber: userNumber)
		}
	}
	func SaveMobileObject(_ userName: String, userNumber: String) {
		var error: Unmanaged<CFError>?
		// 定义一个错误标记对象，判断是否成功
		let addressBook: ABAddressBook? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()

		// 创建一个联系人对象
		let newContact: ABRecord! = ABPersonCreate().takeRetainedValue()
		var success: Bool = false

		// 设置联系人对象昵称
		success = ABRecordSetValue(newContact, kABPersonNicknameProperty, userName as CFTypeRef, &error)
		print("设置昵称结果:\(success)")

		// 设置联系人姓氏
		// success = ABRecordSetValue(newContact, kABPersonLastNameProperty, "李", &error)
		// print("设置姓氏结果:\(success)")

		// 设置联系人名字
		// success = ABRecordSetValue(newContact, kABPersonFirstNameProperty, "大木", &error)
		// print("设置名字结果:\(success)")

		// 设置联系人电话
		let phones: ABMutableMultiValue = ABMultiValueCreateMutable(ABPropertyType(kABStringPropertyType)).takeRetainedValue()
		success = ABMultiValueAddValueAndLabel(phones, userNumber as CFTypeRef, "公司" as CFString, nil)
		print("设置电话条目:\(success)")
		success = ABRecordSetValue(newContact, kABPersonPhoneProperty, phones, nil)
		print("设置电话结果:\(success)")

		// 设置联系人邮箱
		// let addr: ABMutableMultiValueRef = ABMultiValueCreateMutable(ABPropertyType(kABStringPropertyType)).takeRetainedValue()
		// success = ABMultiValueAddValueAndLabel(addr, "ABG@hangge.com", "公司", nil)
		// print("设置邮箱条目结果:\(success)")
		// success = ABRecordSetValue(newContact, kABPersonEmailProperty, addr, nil)
		// print("设置邮箱结果:\(success)")

		// 保存联系人
		success = ABAddressBookAddRecord(addressBook, newContact, &error)
		print("保存记录是否成功:\(success)")

		// 修改数据库
		success = ABAddressBookSave(addressBook, &error)
		print("修改数据库是否成功:\(success)")
        self.dismissActionSheetController({
            alert("保存成功")
        })

    }
	// Mark: -------- 通讯录  所有数据的获取
	func getSysContacts() -> [[String: AnyObject]] {
		var error: Unmanaged<CFError>?
        if !(ABAddressBookCreateWithOptions(nil, &error) != nil) {
            alert("请到设置中打开通讯录授权")
            return [["":"" as AnyObject]]
        }
		var addressBook: ABAddressBook? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        
		let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()

		if sysAddressBookStatus == .denied || sysAddressBookStatus == .notDetermined {
			// Need to ask for authorization
			var authorizedSingal: DispatchSemaphore = DispatchSemaphore(value: 0)
			var askAuthorization: ABAddressBookRequestAccessCompletionHandler = { success, error in
				if success {
					ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
					authorizedSingal.signal()
				}
			}
			ABAddressBookRequestAccessWithCompletion(addressBook, askAuthorization)
			authorizedSingal.wait(timeout: DispatchTime.distantFuture)
		}

		func analyzeSysContacts(_ sysContacts: NSArray) -> [[String: AnyObject]] {
			var allContacts: Array = [[String: AnyObject]]()

			func analyzeContactProperty(_ contact: ABRecord, property: ABPropertyID) -> [AnyObject]? {
				let propertyValues: ABMultiValue? = ABRecordCopyValue(contact, property)?.takeRetainedValue()
				if propertyValues != nil {
					var values: Array<AnyObject> = Array()
					for i in 0 ..< ABMultiValueGetCount(propertyValues) {
						let value = ABMultiValueCopyValueAtIndex(propertyValues, i)
						switch property {
							// 地址
						case kABPersonAddressProperty:
							var valueDictionary: Dictionary = [String: String]()

							let addrNSDict: NSMutableDictionary = value!.takeRetainedValue() as! NSMutableDictionary
							valueDictionary["_Country"] = addrNSDict.value(forKey: kABPersonAddressCountryKey as String) as? String ?? ""
							valueDictionary["_State"] = addrNSDict.value(forKey: kABPersonAddressStateKey as String) as? String ?? ""
							valueDictionary["_City"] = addrNSDict.value(forKey: kABPersonAddressCityKey as String) as? String ?? ""
							valueDictionary["_Street"] = addrNSDict.value(forKey: kABPersonAddressStreetKey as String) as? String ?? ""
							valueDictionary["_Contrycode"] = addrNSDict.value(forKey: kABPersonAddressCountryCodeKey as String) as? String ?? ""

							// 地址整理
							let fullAddress: String = (valueDictionary["_Country"]! == "" ? valueDictionary["_Contrycode"]!: valueDictionary["_Country"]!) + ", " + valueDictionary["_State"]! + ", " + valueDictionary["_City"]! + ", " + valueDictionary["_Street"]!
							values.append(fullAddress as AnyObject)

							// SNS
						case kABPersonSocialProfileProperty:
							var valueDictionary: Dictionary = [String: String]()

							let snsNSDict: NSMutableDictionary = value!.takeRetainedValue() as! NSMutableDictionary
							valueDictionary["_Username"] = snsNSDict.value(forKey: kABPersonSocialProfileUsernameKey as String) as? String ?? ""
							valueDictionary["_URL"] = snsNSDict.value(forKey: kABPersonSocialProfileURLKey as String) as? String ?? ""
							valueDictionary["_Serves"] = snsNSDict.value(forKey: kABPersonSocialProfileServiceKey as String) as? String ?? ""

							values.append(valueDictionary as AnyObject)
							// IM
						case kABPersonInstantMessageProperty:
							var valueDictionary: Dictionary = [String: String]()

							let imNSDict: NSMutableDictionary = value!.takeRetainedValue() as! NSMutableDictionary
							valueDictionary["_Serves"] = imNSDict.value(forKey: kABPersonInstantMessageServiceKey as String) as? String ?? ""
							valueDictionary["_Username"] = imNSDict.value(forKey: kABPersonInstantMessageUsernameKey as String) as? String ?? ""

							values.append(valueDictionary as AnyObject)
							// Date
						case kABPersonDateProperty:
							let date: String? = (value?.takeRetainedValue() as? Date)?.description
							if date != nil {
								values.append(date! as AnyObject)
							}
						default:
							let val: String = value!.takeRetainedValue() as? String ?? ""
							values.append(val as AnyObject)
						}
					}
					return values
				} else {
					return nil
				}
			}

			for contact in sysContacts {
				var currentContact: Dictionary = [String: AnyObject]()
				/*
				 部分单值属性
				 */
				// 姓、姓氏拼音
				let FirstName: String = ABRecordCopyValue(contact as ABRecord, kABPersonFirstNameProperty)?.takeRetainedValue() as! String? ?? ""
				currentContact["FirstName"] = FirstName as AnyObject
				currentContact["FirstNamePhonetic"] = ABRecordCopyValue(contact as ABRecord, kABPersonFirstNamePhoneticProperty)?.takeRetainedValue() as! String? as AnyObject
				// 名、名字拼音
				let LastName: String = ABRecordCopyValue(contact as ABRecord, kABPersonLastNameProperty)?.takeRetainedValue() as! String? ?? ""
				currentContact["LastName"] = LastName as AnyObject
				currentContact["LirstNamePhonetic"] = ABRecordCopyValue(contact as ABRecord, kABPersonLastNamePhoneticProperty)?.takeRetainedValue() as! String? as AnyObject 
				// 昵称
				currentContact["Nikename"] = ABRecordCopyValue(contact as ABRecord, kABPersonNicknameProperty)?.takeRetainedValue() as! String? as AnyObject 

				// 姓名整理
				currentContact["fullName"] = LastName + FirstName as AnyObject

				// 公司（组织）
				currentContact["Organization"] = ABRecordCopyValue(contact as ABRecord, kABPersonOrganizationProperty)?.takeRetainedValue() as! String? as AnyObject 
				// 职位
				currentContact["JobTitle"] = ABRecordCopyValue(contact as ABRecord, kABPersonJobTitleProperty)?.takeRetainedValue() as! String? as AnyObject ?? "" as AnyObject
				// 部门
				currentContact["Department"] = ABRecordCopyValue(contact as ABRecord, kABPersonDepartmentProperty)?.takeRetainedValue() as! String? as AnyObject ?? "" as AnyObject
				// 备注
				currentContact["Note"] = ABRecordCopyValue(contact as ABRecord, kABPersonNoteProperty)?.takeRetainedValue() as! String? as AnyObject ?? "" as AnyObject

				// 获取头像

				if ABPersonHasImageData(contact as ABRecord) {
					let imgData = ABPersonCopyImageDataWithFormat(contact as ABRecord, kABPersonImageFormatOriginalSize).takeRetainedValue()
					let image = UIImage(data: imgData as Data)
					currentContact["TX"] = image
				}

				// 生日（类型转换有问题，不可用）
				// currentContact["Brithday"] = ((ABRecordCopyValue(contact, kABPersonBirthdayProperty)?.takeRetainedValue()) as NSDate).description

				/*w
				 部分多值属性
				 */
				// 电话
				let Phone: Array<AnyObject>? = analyzeContactProperty(contact as ABRecord, property: kABPersonPhoneProperty)
				if Phone != nil {
					currentContact["Phone"] = Phone as AnyObject
				}

				// 地址
				let Address: Array<AnyObject>? = analyzeContactProperty(contact as ABRecord, property: kABPersonAddressProperty)
				if Address != nil {
					currentContact["Address"] = Address as AnyObject
				}

				// E-mail
				let Email: Array<AnyObject>? = analyzeContactProperty(contact as ABRecord, property: kABPersonEmailProperty)
				if Email != nil {
					currentContact["Email"] = Email as AnyObject
				}
				// 纪念日
				let Date: Array<AnyObject>? = analyzeContactProperty(contact as ABRecord, property: kABPersonDateProperty)
				if Date != nil {
					currentContact["Date"] = Date as AnyObject
				}
				// URL
				let URL: Array<AnyObject>? = analyzeContactProperty(contact as ABRecord, property: kABPersonURLProperty)
				if URL != nil {
					currentContact["URL"] = URL as AnyObject
				}
				// SNS
				let SNS: Array<AnyObject>? = analyzeContactProperty(contact as ABRecord, property: kABPersonSocialProfileProperty)
				if SNS != nil {
					currentContact["SNS"] = SNS as AnyObject
				}
				allContacts.append(currentContact)
			}
			return allContacts
		}
		return analyzeSysContacts(ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray)
	}
	// Mark: -------- 手机号正则表达式
	func checkMobileReg(_ mobile: String) -> Bool {
		let regex = try! NSRegularExpression(pattern: REGEXP_MOBILES,
			options: [.caseInsensitive])

		return regex.firstMatch(in: mobile, options: [],
			range: NSRange(location: 0, length: mobile.utf16.count))?.range.length != nil

	}
	@IBAction func canle(_ sender: AnyObject) {
		self.dismissActionSheetController()
	}
	func isempty() -> Bool {
		if let name = userName, let number = userNumber {
			if name == "" || number == "" {
				return true
			}
			if checkMobileReg(number) {
				return false
			} else {
				return true
			}
		}
		return false
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}


}

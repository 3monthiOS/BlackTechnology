//
//  MObileFunction.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/7/8.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import UIKit
import Swiften
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

	private static var sharedInstance: MObileFunction? = nil
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
	override func viewWillAppear(animated: Bool) {
		if isShow {
			SaveBtn.hidden = false
		} else {
			SaveBtn.hidden = true
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()

	}
	// Mark:- -------保存次联系人 到电话簿
	@IBAction func saveMobilephone(sender: AnyObject) {
		if isempty() { alert("联系人信息不完整"); return }
		self.SaveMobileBook(userName!, userNumber: userNumber!)
	}
	// Mark:- -------打电话
	@IBAction func IphoneCall(sender: AnyObject) {
		if isempty() { alert("联系人信息不完整"); return }
		self.phoneCall(userNumber!)
//		self.dismissActionSheetController()
	}
	func phoneCall(phoneStr: String) {
		let phoneNum = "tel:\(phoneStr)"
		let callWedView = UIWebView()
		let request = NSURLRequest(URL: NSURL(string: phoneNum)!)
		callWedView.loadRequest(request)
		self.view.addSubview(callWedView)
	}
	// Mark:- -------推荐
	@IBAction func recommended(sender: AnyObject) {
	}
	// Mark:- -------发短信
	@IBAction func texting(sender: AnyObject) {
		self.sendMessage(self,MessageContent: "")
	}
    func sendMessage(controller: UIViewController, MessageContent: String) {
        self.messageBoy = MessageContent
		if (self.canSendText()) {
			controller.presentViewController(self.configuredMessageComposeViewController(), animated: true, completion: nil)
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
	func messageComposeViewController(controller: MFMessageComposeViewController,
		didFinishWithResult result: MessageComposeResult) {

			switch result {
			case .Sent:
				print("短信已发送")
			case .Cancelled:
				print("短信取消发送")
			case .Failed:
				print("短信发送失败")
			}
			controller.dismissViewControllerAnimated(true, completion: nil)
			MObileFunction.sharedInstance = nil
	}

	// Mark: -------- 创建新的联系人
	func EditNewContacts() {
		let personViewVC = ABPersonViewController()
		personViewVC.personViewDelegate = self
		personViewVC.allowsEditing = true
		personViewVC.editing = true
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
	func personViewController(personViewController: ABPersonViewController, shouldPerformDefaultActionForPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
		return false
	}
	func newPersonViewController(newPersonView: ABNewPersonViewController, didCompleteWithNewPerson person: ABRecord?) {
		//
	}

	// Mark: -------- 平台 保存到通讯录
	func SaveMobileBook(userName: String, userNumber: String) {

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
			saveRequest.addContact(mutableContact, toContainerWithIdentifier: nil)
			do {
				try ContactsStore.sharedStore.executeSaveRequest(saveRequest)
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
	func SaveMobileObject(userName: String, userNumber: String) {
		var error: Unmanaged<CFErrorRef>?
		// 定义一个错误标记对象，判断是否成功
		let addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()

		// 创建一个联系人对象
		let newContact: ABRecordRef! = ABPersonCreate().takeRetainedValue()
		var success: Bool = false

		// 设置联系人对象昵称
		success = ABRecordSetValue(newContact, kABPersonNicknameProperty, userName, &error)
		print("设置昵称结果:\(success)")

		// 设置联系人姓氏
		// success = ABRecordSetValue(newContact, kABPersonLastNameProperty, "李", &error)
		// print("设置姓氏结果:\(success)")

		// 设置联系人名字
		// success = ABRecordSetValue(newContact, kABPersonFirstNameProperty, "大木", &error)
		// print("设置名字结果:\(success)")

		// 设置联系人电话
		let phones: ABMutableMultiValueRef = ABMultiValueCreateMutable(ABPropertyType(kABStringPropertyType)).takeRetainedValue()
		success = ABMultiValueAddValueAndLabel(phones, userNumber, "公司", nil)
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
            return [["":""]]
        }
		var addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        
		let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()

		if sysAddressBookStatus == .Denied || sysAddressBookStatus == .NotDetermined {
			// Need to ask for authorization
			var authorizedSingal: dispatch_semaphore_t = dispatch_semaphore_create(0)
			var askAuthorization: ABAddressBookRequestAccessCompletionHandler = { success, error in
				if success {
					ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
					dispatch_semaphore_signal(authorizedSingal)
				}
			}
			ABAddressBookRequestAccessWithCompletion(addressBook, askAuthorization)
			dispatch_semaphore_wait(authorizedSingal, DISPATCH_TIME_FOREVER)
		}

		func analyzeSysContacts(sysContacts: NSArray) -> [[String: AnyObject]] {
			var allContacts: Array = [[String: AnyObject]]()

			func analyzeContactProperty(contact: ABRecordRef, property: ABPropertyID) -> [AnyObject]? {
				let propertyValues: ABMultiValueRef? = ABRecordCopyValue(contact, property)?.takeRetainedValue()
				if propertyValues != nil {
					var values: Array<AnyObject> = Array()
					for i in 0 ..< ABMultiValueGetCount(propertyValues) {
						let value = ABMultiValueCopyValueAtIndex(propertyValues, i)
						switch property {
							// 地址
						case kABPersonAddressProperty:
							var valueDictionary: Dictionary = [String: String]()

							let addrNSDict: NSMutableDictionary = value.takeRetainedValue() as! NSMutableDictionary
							valueDictionary["_Country"] = addrNSDict.valueForKey(kABPersonAddressCountryKey as String) as? String ?? ""
							valueDictionary["_State"] = addrNSDict.valueForKey(kABPersonAddressStateKey as String) as? String ?? ""
							valueDictionary["_City"] = addrNSDict.valueForKey(kABPersonAddressCityKey as String) as? String ?? ""
							valueDictionary["_Street"] = addrNSDict.valueForKey(kABPersonAddressStreetKey as String) as? String ?? ""
							valueDictionary["_Contrycode"] = addrNSDict.valueForKey(kABPersonAddressCountryCodeKey as String) as? String ?? ""

							// 地址整理
							let fullAddress: String = (valueDictionary["_Country"]! == "" ? valueDictionary["_Contrycode"]!: valueDictionary["_Country"]!) + ", " + valueDictionary["_State"]! + ", " + valueDictionary["_City"]! + ", " + valueDictionary["_Street"]!
							values.append(fullAddress)

							// SNS
						case kABPersonSocialProfileProperty:
							var valueDictionary: Dictionary = [String: String]()

							let snsNSDict: NSMutableDictionary = value.takeRetainedValue() as! NSMutableDictionary
							valueDictionary["_Username"] = snsNSDict.valueForKey(kABPersonSocialProfileUsernameKey as String) as? String ?? ""
							valueDictionary["_URL"] = snsNSDict.valueForKey(kABPersonSocialProfileURLKey as String) as? String ?? ""
							valueDictionary["_Serves"] = snsNSDict.valueForKey(kABPersonSocialProfileServiceKey as String) as? String ?? ""

							values.append(valueDictionary)
							// IM
						case kABPersonInstantMessageProperty:
							var valueDictionary: Dictionary = [String: String]()

							let imNSDict: NSMutableDictionary = value.takeRetainedValue() as! NSMutableDictionary
							valueDictionary["_Serves"] = imNSDict.valueForKey(kABPersonInstantMessageServiceKey as String) as? String ?? ""
							valueDictionary["_Username"] = imNSDict.valueForKey(kABPersonInstantMessageUsernameKey as String) as? String ?? ""

							values.append(valueDictionary)
							// Date
						case kABPersonDateProperty:
							let date: String? = (value.takeRetainedValue() as? NSDate)?.description
							if date != nil {
								values.append(date!)
							}
						default:
							let val: String = value.takeRetainedValue() as? String ?? ""
							values.append(val)
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
				let FirstName: String = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?.takeRetainedValue() as! String? ?? ""
				currentContact["FirstName"] = FirstName
				currentContact["FirstNamePhonetic"] = ABRecordCopyValue(contact, kABPersonFirstNamePhoneticProperty)?.takeRetainedValue() as! String? ?? ""
				// 名、名字拼音
				let LastName: String = ABRecordCopyValue(contact, kABPersonLastNameProperty)?.takeRetainedValue() as! String? ?? ""
				currentContact["LastName"] = LastName
				currentContact["LirstNamePhonetic"] = ABRecordCopyValue(contact, kABPersonLastNamePhoneticProperty)?.takeRetainedValue() as! String? ?? ""
				// 昵称
				currentContact["Nikename"] = ABRecordCopyValue(contact, kABPersonNicknameProperty)?.takeRetainedValue() as! String? ?? ""

				// 姓名整理
				currentContact["fullName"] = LastName + FirstName

				// 公司（组织）
				currentContact["Organization"] = ABRecordCopyValue(contact, kABPersonOrganizationProperty)?.takeRetainedValue() as! String? ?? ""
				// 职位
				currentContact["JobTitle"] = ABRecordCopyValue(contact, kABPersonJobTitleProperty)?.takeRetainedValue() as! String? ?? ""
				// 部门
				currentContact["Department"] = ABRecordCopyValue(contact, kABPersonDepartmentProperty)?.takeRetainedValue() as! String? ?? ""
				// 备注
				currentContact["Note"] = ABRecordCopyValue(contact, kABPersonNoteProperty)?.takeRetainedValue() as! String? ?? ""

				// 获取头像

				if ABPersonHasImageData(contact) {
					let imgData = ABPersonCopyImageDataWithFormat(contact, kABPersonImageFormatOriginalSize).takeRetainedValue()
					let image = UIImage(data: imgData)
					currentContact["TX"] = image
				}

				// 生日（类型转换有问题，不可用）
				// currentContact["Brithday"] = ((ABRecordCopyValue(contact, kABPersonBirthdayProperty)?.takeRetainedValue()) as NSDate).description

				/*w
				 部分多值属性
				 */
				// 电话
				let Phone: Array<AnyObject>? = analyzeContactProperty(contact, property: kABPersonPhoneProperty)
				if Phone != nil {
					currentContact["Phone"] = Phone
				}

				// 地址
				let Address: Array<AnyObject>? = analyzeContactProperty(contact, property: kABPersonAddressProperty)
				if Address != nil {
					currentContact["Address"] = Address
				}

				// E-mail
				let Email: Array<AnyObject>? = analyzeContactProperty(contact, property: kABPersonEmailProperty)
				if Email != nil {
					currentContact["Email"] = Email
				}
				// 纪念日
				let Date: Array<AnyObject>? = analyzeContactProperty(contact, property: kABPersonDateProperty)
				if Date != nil {
					currentContact["Date"] = Date
				}
				// URL
				let URL: Array<AnyObject>? = analyzeContactProperty(contact, property: kABPersonURLProperty)
				if URL != nil {
					currentContact["URL"] = URL
				}
				// SNS
				let SNS: Array<AnyObject>? = analyzeContactProperty(contact, property: kABPersonSocialProfileProperty)
				if SNS != nil {
					currentContact["SNS"] = SNS
				}
				allContacts.append(currentContact)
			}
			return allContacts
		}
		return analyzeSysContacts(ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray)
	}
	// Mark: -------- 手机号正则表达式
	func checkMobileReg(mobile: String) -> Bool {
		let regex = try! NSRegularExpression(pattern: REGEXP_MOBILES,
			options: [.CaseInsensitive])

		return regex.firstMatchInString(mobile, options: [],
			range: NSRange(location: 0, length: mobile.utf16.count))?.range.length != nil

	}
	@IBAction func canle(sender: AnyObject) {
		self.dismissActionSheetController()
	}
	func isempty() -> Bool {
		if let name = userName, number = userNumber {
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

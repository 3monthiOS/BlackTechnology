//
//  RetrieveMobileAddressbook.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/7/7.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
class RetrieveMobileAddressbook: NSObject {
	var strings = "" // 联系人姓名
	var pinYin = "" // 首字母

    // MARK: -  返回tableview右方 indexArray
	func IndexArray(_ stringArr: [String]) -> [String] {
		let tempArray = ReturnSortChineseArrar(stringArr)
		var A_Result = [String]()
		var tempString =  ""
		for object in tempArray {
			let pin = String(object.pinYin.characters.first!)
			if tempString != pin {
                tempString = pin
				A_Result.append(pin)
			}
		}
		return A_Result
	}
    // MARK: -  返回一组字母排序数组
	func SortArray(_ stringArr: [String]) -> [String] {
		var stringArray = [String]()
		let tempArray = ReturnSortChineseArrar(stringArr)
		for obj in tempArray {
			stringArray.append(obj.strings)
		}
		return stringArray
	}

    // MARK: -  返回联系人
	func LetterSortArray(_ stringArr: [String]) -> [AnyObject] {
		let tempArray = ReturnSortChineseArrar(stringArr)
        var LetterResult : Array<Array<String>> = []
        var item = [String]()
		var tempString: Character?
		for object in tempArray {
			let pin = object.pinYin.characters.first
			if tempString != pin {
                item.removeAll()
				item.append(object.strings)
				LetterResult.append(item)
				tempString = pin!
			} else {
                LetterResult[LetterResult.count-1].append(object.strings)
			}
		}
        
        
		return LetterResult as [AnyObject]
	}
    // MARK: - 过滤指定字符串   里面的指定字符根据自己的需要添加
	func RemoveSpecialCharacter(_ str: String) -> String {
		let range = str.rangeOfCharacter(from: CharacterSet(charactersIn: "-,.？、% ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"))
		if range != nil {
			return self.RemoveSpecialCharacter(str.replacingCharacters(in: range!, with: ""))
		}
		return str
	}
    // MARK: - 中文转换 拼音
    func chineseConversionPinYin(_ str:String)->String{
            let strpinyin = NSMutableString(string:str) as CFMutableString
        if CFStringTransform(strpinyin, nil, kCFStringTransformToLatin, false){
            if CFStringTransform(strpinyin, nil, kCFStringTransformStripDiacritics, false){
                return strpinyin as String
            }
        }
        print("\(str)---------无法转换成拼音-----")
        return ""
    }

	// MARK: -  返回排序好的字符拼音
	func ReturnSortChineseArrar(_ stringArr: [String]) -> [RetrieveMobileAddressbook] {
		var chineseStringsArray = [RetrieveMobileAddressbook]()
		for str in stringArr {
            let chineseString = RetrieveMobileAddressbook()
			if str.isEmpty {
				chineseString.strings = ""
			} else {
				chineseString.strings = str
			}
			// 去除两端空格和回车
			chineseString.strings = chineseString.strings.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
			chineseString.strings = self.RemoveSpecialCharacter(chineseString.strings)
			// 判断首字符是否为字母
			let regex = "[A-Za-z]+"
			let predicate = NSPredicate.init(format: "SELF MATCHES %@", regex)

			if predicate.evaluate(with: chineseString.strings) {
				// 首字母大写
				chineseString.pinYin = chineseString.strings.capitalized
			} else {
                let strPinYin = chineseConversionPinYin(chineseString.strings)
				if !strPinYin.isEmpty {
					for char in strPinYin.characters {
						if char == " " {
							continue
						}
                        let range = strPinYin.range(of: char.description)
                        let r = strings.nsRange(from: range!)
                        chineseString.pinYin = String(strPinYin.characters.dropFirst(r.location)).capitalized
						break
					}
				} else {
					chineseString.pinYin = ""
				}
			}
            chineseStringsArray.append(chineseString)
		}
        let array = chineseStringsArray
        chineseStringsArray = array.sorted(by: {$0.pinYin < $1.pinYin})
		return chineseStringsArray
	}
}


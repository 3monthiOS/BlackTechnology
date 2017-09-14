//
//  Sort.swift
//  App
//
//  Created by 红军张 on 2017/9/8.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation

protocol SortType {
    func sort(items: Array<Int>) -> Array<Int>
    func setEveryStepClosure(everyStepClosure: @escaping SortResultClosure,
                             sortSuccessClosure: @escaping SortSuccessClosure) -> Void
}

//
// Created by 红军张 on 2017/5/22.
// Copyright (c) 2017 IndependentRegiment. All rights reserved.
//

import Foundation

// MARK: --
extension Array{
    subscript (safe index: Int) ->Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }

    subscript(i1: Int, i2: Int, rest: Int...) -> [Element] {
              //通过实现get方法，获取数组中相应的值
        get {
            var result: [Element] = [self[i1], self[i2]]
            for index in rest {
                result.append(self[index])
            }
            return result
        }
            //通过set方法，对数组相应的索引进行设置
        set (values) {
            for (index, value) in zip([i1, i2] + rest, values) {
                self[index] = value
            }
        }
    }
}

// MARK: -- IndexSet
extension IndexSet {
    func bs_indexPathsForSection(_ section: Int) -> [IndexPath] {
        return self.map { IndexPath(item: $0, section: section) }
    }
}

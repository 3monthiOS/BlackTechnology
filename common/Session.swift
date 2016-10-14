//
// Created by Cator Vee on 7/8/16.
// Copyright (c) 2016 侯伟. All rights reserved.
//

import Foundation
import Swiften

extension Session {

    /** appid */
    var appid: String {
        return user?.appid ?? ""
//        get { return string(forKey: "APPID", defaultValue: "") }
//        set { setObject(newValue, forKey: "APPID") }
    }

    /** passport */
    var passport: String {
        return user?.passport ?? ""
//        get { return string(forKey: "PASSPORT", defaultValue: "") }
//        set { setObject(newValue, forKey: "PASSPORT") }
    }

    /** openid */
    var openid: String {
        return user?.openid ?? ""
//        get { return string(forKey: "OPENID", defaultValue: "") }
//        set { setObject(newValue, forKey: "OPENID") }
    }

    /// cityUrl
    var cityUrl: String {
        get { return string(forKey: "CITYURL", defaultValue: "") }
        set { setObject(newValue, forKey: "CITYURL") }
    }

    /// 是否已登录
    var isAuthed: Bool {
        return user != nil
    }

    /// 当前登录用户
    var user: LoginUser? {
        if let user: LoginUser = cache.objectForKey(.User) {
            return user
        }
        return nil
    }

    func logout() {
        cache.remove(.User)
        cache.remove(.RongCloudToken)
    }

}

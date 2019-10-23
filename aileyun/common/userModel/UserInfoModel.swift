//
//  UserInfoModel.swift
//  aileyun
//
//  Created by huchuang on 2017/6/19.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class UserInfoModel: NSObject {
    
    var city : NSString?
    var headimgurl : NSString?
    var unionid : NSString?
    var privilege : NSArray?
    var openid : NSString?
    var nickname : NSString?
    var language : NSString?
    var province : NSString?
    var sex : NSNumber?
    var country : NSString?
    
    //需要绑定
    var phone : NSString?
    //密码设置
    var password : NSString?
    
    
    convenience init(_ dic : [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //
    }

}

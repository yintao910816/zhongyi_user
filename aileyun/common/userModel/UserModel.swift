//
//  UserModel.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/24.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    var access_token : NSString?
    var expires_in : NSNumber?
    var openid : NSString?
    var refresh_token : NSString?
    var unionid : NSString?

    
    convenience init(_ dic : [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //
    }
    
}

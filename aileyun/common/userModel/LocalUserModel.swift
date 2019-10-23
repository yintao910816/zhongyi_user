//
//  LocalUserModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class LocalUserModel: NSObject {
    
    var headImg : NSString?
    var nickName : NSString?
    var realName : NSString?
    var token : NSString?
    var visitCard : NSString?
    
    //额外
    var phone : String?
    
    convenience init(_ dic : [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //
    }
}




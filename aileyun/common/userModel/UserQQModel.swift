//
//  UserQQModel.swift
//  aileyun
//
//  Created by huchuang on 2017/6/22.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class UserQQModel: NSObject, HandyJSON {

    
    var nickname : NSString?
    var gender : NSString?
    var figureurl_qq_2 : NSString?
    
    var accessToken : String?
    var openId : String?
    var expirationDate : Date?
    
    
//    convenience init(_ dic : [String : Any]) {
//        self.init()
//        setValuesForKeys(dic)
//    }
//
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        //
//    }

    required override init() {
        
    }

}

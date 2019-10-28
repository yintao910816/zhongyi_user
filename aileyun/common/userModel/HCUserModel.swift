//
//  HCUserModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/27.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class HCUserModel: NSObject, HandyJSON {

    var phone : String?
    var nickname : String?
    var hospitalId : NSNumber?
    var id : NSNumber?
    var token : String?
    
    
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

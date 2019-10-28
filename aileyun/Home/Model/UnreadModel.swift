//
//  UnreadModel.swift
//  aileyun
//
//  Created by huchuang on 2017/12/21.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class UnreadModel: NSObject, HandyJSON {
    
    var unread : NSNumber?
    var patientId : NSNumber?

    // MARK:- 构造函数
//    init(_ dict : [String : Any]) {
//        super.init()
//        setValuesForKeys(dict)
//    }
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    required override init() {
        
    }
}

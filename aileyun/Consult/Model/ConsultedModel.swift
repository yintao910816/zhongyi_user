//
//  ConsultedModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/13.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class ConsultedModel: NSObject, HandyJSON {
    
    var doctorId : String?
    var doctorName : String?
    var doctorImg : String?
    var doctorRole : String?
    
    // MARK:- 构造函数
//    init(_ dict : [String : Any]) {
//        super.init()
//
//        setValuesForKeys(dict)
//    }
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

    required override init() {
        
    }

}

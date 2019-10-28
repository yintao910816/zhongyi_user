//
//  DoctorModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class DoctorCommentModel: NSObject, HandyJSON {
    
    var discribe : String?
    var name : String?
    var other : String?
    
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

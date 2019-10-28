//
//  HospitalListModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/3.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class HospitalListModel: NSObject, HandyJSON {

    var id : String?
    var name : String?
    var other : String?
    
    var discribe : String?
    
    var abbreviation : String?
    var address : String?
    
//    // MARK:- 构造函数
//    init(_ dict : [String : Any]) {
//        super.init()
//
//        setValuesForKeys(dict)
//    }
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

    required override init() {
        
    }

}

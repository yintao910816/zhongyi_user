//
//  GoodNewsModel.swift
//  aileyun
//
//  Created by huchuang on 2017/11/11.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class GoodNewsModel: NSObject {
    
    var name : String = "匿名"
    var pid : String?
    var appId : String?
    var count : String?
    var oid : String?
    var deliver : String = "2017-11-11"
    var mCardNo : String?
    var type : String = "pregnant"   //childbirth
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}

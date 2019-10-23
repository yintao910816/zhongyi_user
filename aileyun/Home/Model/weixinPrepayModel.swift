//
//  weixinPrepayModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/24.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class weixinPrepayModel: NSObject {
    
    var appid : String?
    var partnerid : String?
    var noncestr : String?
    var prepayid : String?
    var timestamp : String?
    var sign : String?
    var packageValue : String?
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}


}

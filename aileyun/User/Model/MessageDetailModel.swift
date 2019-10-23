//
//  MessageDetailModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/22.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class MessageDetailModel: NSObject {
    
    var readStatus : NSNumber?
    var content : String?
    var id : NSNumber?
    var deviceType : String?
    var isSucceedSend : NSNumber?
    
    var from : String?
    var extra : String?
    var title : String?
    var to : String?
    var type : NSNumber?

    
    var isSucceedReceived : NSNumber?
    var pushTime : NSNumber?

    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}


}

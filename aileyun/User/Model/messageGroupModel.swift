//
//  messageGroupModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/22.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class messageGroupModel: NSObject {
    
    var content : String?
    
    var title : String?
    
    //什么类型
    var type : NSNumber?
    
    var notifyGroupCount : NSNumber?
    var pushTime : NSNumber?
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}


}

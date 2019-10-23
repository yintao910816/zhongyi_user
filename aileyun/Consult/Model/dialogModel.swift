//
//  dialogModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/14.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class dialogModel: NSObject {
    var type : String?
    
    var headImg : String?
    var content : String?
    var consultTime : String?
    
    //来自谁？
    var status : String?
    
    //有可能是数组
    var picList : String?
    
    
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        get{
            return "type\(type)" + "content\(content)" + "consultTime\(consultTime)" + "status\(status)" + "headImg\(headImg)" + "picList\(picList)"
        }
    }

}

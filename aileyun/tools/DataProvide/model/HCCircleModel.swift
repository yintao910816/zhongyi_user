//
//  HCCircleModel.swift
//  aileyun
//
//  Created by huchuang on 2017/9/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HCCircleModel: NSObject {
    
    var labelNames : NSArray?
    var brief : String?
    var headPhoto : String?
    var id : String?
    var likeCount : NSNumber?
    var imgUrls : NSArray?
    var viewCount : String?
    var nickName : String?
    var title : String?
    var createTime : String?
    var replayCount : String?

    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

//
//  HomeBannerModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/28.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HomeBannerModel: NSObject {
    
    var clickCount : String?
    var path : String?
    var id : NSNumber?
    var updateTime : NSNumber?
    var title : String?
    var type : NSNumber?
    var createTime : NSNumber?
    var url : String?
    var order : String?
    var hospitalId : NSNumber?
    
    
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}

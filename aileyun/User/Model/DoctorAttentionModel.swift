//
//  DoctorAttentionModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/24.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class DoctorAttentionModel: NSObject {
    
//    doctorId = 14;
//    doctorName = "\U66f2\U5e86\U5170";
//    doctorRoleName = "\U526f\U4e3b\U4efb\U533b\U5e08";
    
    
    var doctorRoleName : String?
    var doctorId : NSNumber?
    var doctorName : String?
    
    var imgUrl : String?
    
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}


}

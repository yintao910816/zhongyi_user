//
//  HC_consultAddModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/27.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HC_consultAddModel: NSObject {
    
    var content : String?
    var patientName : String?
    var doctorId : NSNumber?
    var feeStatus : NSNumber?
    var id : NSNumber?
    
    var patientId : NSNumber?
    var doctorName : String?
    var imageList : String?
    var patientAccount : String?
    var currentStatus : NSNumber?
    
    var fee : NSNumber?

    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}

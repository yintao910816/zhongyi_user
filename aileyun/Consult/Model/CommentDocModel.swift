//
//  CommentDocModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/24.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class CommentDocModel: NSObject {
    
    
    var reviewCount : NSNumber?
    var doctorId : NSNumber?
    var patientAccount : String?
    var patientId : NSNumber?
    var consId : NSNumber?
    
    var reviewContent : String?
    var reviewStatus : NSNumber?
    
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}

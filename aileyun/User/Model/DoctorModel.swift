//
//  DoctorAttentionModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class DoctorModel: NSObject {
    
    
    var doctorId : NSNumber?
    var consultCount : NSNumber?
    var hospitalName : String?
    var realName : String?
    var replyCount : NSNumber?
    
    var brif : String?
    var reviewNum : NSNumber?
    var reviewStar : NSNumber?
    var consultation : NSNumber?
    var imgUrl : String?
    
    var hospitalId : NSNumber?
    var doctorRole : String?
    var docPrice : String?
    var goodProject : String?

    
    
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    


}

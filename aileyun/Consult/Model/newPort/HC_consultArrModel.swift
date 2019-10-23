//
//  HC_consultArrModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/25.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HC_consultArrModel: NSObject {
    
    var doctorId : NSNumber?
    var imageList : String?
    var doctorImg : String?
    var fee : NSNumber?
    var Id : NSNumber?
    
    var content : String?
    var feeStatus : NSNumber?
    var doctorName : String?
    var replyList : NSArray?
    var currentStatus : NSNumber?
    
    var reviewStatus : NSNumber?  // 0 未评价
    var hospitalId : NSNumber?
    var feeTimes : NSNumber?
    var createTime : NSNumber?
    var docPrice : String?
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["replyList" : HC_consultListModel.classForCoder()]
    }

}

//
//  HC_consultArrModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/25.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class HC_consultArrModel: NSObject, HandyJSON {
    
    var doctorId : NSNumber?
    var imageList : String?
    var doctorImg : String?
    var fee : NSNumber?
    var Id : NSNumber?
    
    var content : String?
    var feeStatus : NSNumber?
    var doctorName : String?
    var replyList : [HC_consultListModel] = []
    var currentStatus : NSNumber?
    
    var reviewStatus : NSNumber?  // 0 未评价
    var hospitalId : NSNumber?
    var feeTimes : NSNumber?
    var createTime : NSNumber?
    var docPrice : String?
    
//    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
//        return ["replyList" : HC_consultListModel.classForCoder()]
//    }

    required override init() {
        
    }
}
